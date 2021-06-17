#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=4
samtools_PATH=/opt/software/samtools/1.10/bin/samtools
bwa_PATH=/opt/software/bwa/0.7/bin/bwa
filtered_mapping_score_in_bam=10


work_dir=`pwd`
chmod +x -R $work_dir/*


Parent_A_ref=${work_dir}/Parent_A_ref_seq_development/Parent_A_ref.fa

mkdir Parent_A_self_alignment
cd Parent_A_self_alignment
perl ../script/making_bwa_format_for_Parent_A.pl ${work_dir}/read_information/Parent_A_reads.txt ${Parent_A_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*
mkdir links
cat ex_for_link_Parent_A_reads.txt|xargs -P ${used_cpu} -0 -I % sh -c %
cat ex_for_alignment_Parent_A_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_Parent_A_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_Parent_A_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



Parent_A_bam_file=`ls Parent_A_*.bam`
Parent_A_bam_file_alley=(`ls Parent_A_*.bam`)
num_of_Parent_A_bam_file_alley=`echo ${#Parent_A_bam_file_alley[*]}`
if test 1 -eq ${num_of_Parent_A_bam_file_alley} ; then
  cp ${Parent_A_bam_file} Parent_A_all_temp.bam
else
  $samtools_PATH merge Parent_A_all_temp.bam ${Parent_A_bam_file}
fi

# fix PG line error in samtools view
$samtools_PATH reheader -P -c 'grep -v ^@PG' Parent_A_all_temp.bam > PG_corrected_Parent_A_all_temp.bam
# rename PG corrected bam to old bam name to avoid discrepancies in the code downstream
rm Parent_A_all_temp.bam
mv PG_corrected_Parent_A_all_temp.bam Parent_A_all_temp.bam


perl ../script/bam_filter.pl Parent_A_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH


rm Parent_A_temp*.bam
$samtools_PATH sort --no-PG -T Parent_A_temp -@ ${used_cpu} f_Parent_A_all_temp.bam -o Parent_A_all_merge.bam
rm Parent_A_all_temp.bam


$samtools_PATH rmdup Parent_A_all_merge.bam Parent_A_all_merge_rmdup.bam


$samtools_PATH view --no-PG -b -f 4 Parent_A_all_merge_rmdup.bam > Parent_A_all_unmapped.bam
$samtools_PATH view --no-PG -b -F 4 Parent_A_all_merge_rmdup.bam > Parent_A_all_mapped.bam
$samtools_PATH sort --no-PG -T Parent_A_temp -@ ${used_cpu} Parent_A_all_mapped.bam -o Parent_A_all_mapped_sort_temp.bam
rm Parent_A_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine Parent_A_all_mapped_sort_temp.bam -r ${Parent_A_ref} -pref Parent_A_all_mapped_sort
mv Parent_A_all_mapped_sort_temp.bam Parent_A_all_mapped_sort.bam
# rm Parent_A_all_mapped_sort_temp.bam

$samtools_PATH index Parent_A_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl Parent_A_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl Parent_A_all_mapped_sort.bam $samtools_PATH
