#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=4
samtools_PATH=/opt/software/samtools/1.10/bin/samtools
bwa_PATH=/opt/software/bwa/0.7/bin/bwa
filtered_depth=5
filtered_snp_index=0
filtered_mapping_score_in_bam=10

work_dir=`pwd`
chmod +x -R $work_dir/*


Parent_A_ref=${work_dir}/Parent_A_ref_seq_development/Parent_A_ref.fa
Parent_A_self_bam=${work_dir}/Parent_A_self_alignment/Parent_A_all_mapped_sort.bam

mkdir Tall_to_Parent_A_alignment
cd Tall_to_Parent_A_alignment
perl ../script/making_bwa_format_for_Tall.pl ${work_dir}/read_information/Tall_reads.txt ${Parent_A_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*
mkdir links
cat ex_for_link_Tall_reads.txt|xargs -P ${used_cpu} -0 -I % sh -c %
cat ex_for_alignment_Tall_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_Tall_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_Tall_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



Tall_bam_file=`ls Tall_*.bam`
Tall_bam_file_alley=(`ls Tall_*.bam`)
num_of_Tall_bam_file_alley=`echo ${#Tall_bam_file_alley[*]}`
if test 1 -eq ${num_of_Tall_bam_file_alley} ; then
  cp ${Tall_bam_file} Tall_all_temp.bam
else
  $samtools_PATH merge Tall_all_temp.bam ${Tall_bam_file}
fi

# fix PG line error in samtools view                                                                                                                                                                    
$samtools_PATH reheader -P -c 'grep -v ^@PG' Tall_all_temp.bam > PG_corrected_Tall_all_temp.bam
# rename PG corrected bam to old bam name to avoid discrepancies in the code downstream                                                                                                                   
rm Tall_all_temp.bam
mv PG_corrected_Tall_all_temp.bam Tall_all_temp.bam


perl ../script/bam_filter.pl Tall_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm Tall_temp*.bam
$samtools_PATH sort --no-PG -T Tall_temp -@ ${used_cpu} f_Tall_all_temp.bam -o Tall_all_merge.bam
rm Tall_all_temp.bam

$samtools_PATH rmdup Tall_all_merge.bam Tall_all_merge_rmdup.bam


$samtools_PATH view --no-PG -b -f 4 Tall_all_merge_rmdup.bam > Tall_all_unmapped.bam
$samtools_PATH view --no-PG -b -F 4 Tall_all_merge_rmdup.bam > Tall_all_mapped.bam
$samtools_PATH sort --no-PG -T Tall_temp -@ ${used_cpu} Tall_all_mapped.bam -o Tall_all_mapped_sort_temp.bam
rm Tall_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine Tall_all_mapped_sort_temp.bam -r ${Parent_A_ref} -pref Tall_all_mapped_sort
mv Tall_all_mapped_sort_temp.bam Tall_all_mapped_sort.bam
# rm Tall_all_mapped_sort_temp.bam
$samtools_PATH index Tall_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl Tall_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl Tall_all_mapped_sort.bam $samtools_PATH
