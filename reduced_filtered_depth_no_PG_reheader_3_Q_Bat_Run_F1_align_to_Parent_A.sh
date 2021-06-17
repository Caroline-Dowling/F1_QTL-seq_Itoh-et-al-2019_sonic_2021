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
defined_p_value=0.05
work_dir=`pwd`
chmod +x -R $work_dir/*


Parent_A_ref=${work_dir}/Parent_A_ref_seq_development/Parent_A_ref.fa


mkdir F1_to_Parent_A_alignment
cd F1_to_Parent_A_alignment
perl ../script/making_bwa_format_for_F1.pl ${work_dir}/read_information/F1_reads.txt ${Parent_A_ref} ${bwa_PATH} ${samtools_PATH}
chmod +x -R $work_dir/*
mkdir links
cat ex_for_link_F1_reads.txt|xargs -P ${used_cpu} -0 -I % sh -c %
cat ex_for_alignment_F1_reads.txt|xargs -P ${used_cpu} -I % sh -c %
cat ex_for_sam_development_F1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sai
cat ex_for_bam_development_F1_reads.txt|xargs -P${used_cpu} -I % sh -c %
rm *temp*.sam



F1_bam_file=`ls F1_*.bam`
F1_bam_file_alley=(`ls F1_*.bam`)
num_of_F1_bam_file_alley=`echo ${#F1_bam_file_alley[*]}`
if test 1 -eq ${num_of_F1_bam_file_alley} ; then
  cp ${F1_bam_file} F1_all_temp.bam
else
  $samtools_PATH merge F1_all_temp.bam ${F1_bam_file}
fi

# fix PG line error in samtools view                                                                                                                                                                        
$samtools_PATH reheader -P -c 'grep -v ^@PG' F1_all_temp.bam > PG_corrected_F1_all_temp.bam
# rename PG corrected bam to old bam name to avoid discrepancies in the code downstream                                                                                                                    
rm F1_all_temp.bam
mv PG_corrected_F1_all_temp.bam F1_all_temp.bam

perl ../script/bam_filter.pl F1_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

rm F1_temp*.bam
$samtools_PATH sort --no-PG -T F1_temp -@ ${used_cpu} f_F1_all_temp.bam -o F1_all_merge.bam
rm F1_all_temp.bam

$samtools_PATH rmdup F1_all_merge.bam F1_all_merge_rmdup.bam


$samtools_PATH view --no-PG -b -f 4 F1_all_merge_rmdup.bam > F1_all_unmapped.bam
$samtools_PATH view --no-PG -b -F 4 F1_all_merge_rmdup.bam > F1_all_mapped.bam
$samtools_PATH sort --no-PG -T F1_temp -@ ${used_cpu} F1_all_mapped.bam -o F1_all_mapped_sort_temp.bam
rm F1_all_mapped.bam
# ../original_scripts/Coval-1.4/coval refine F1_all_mapped_sort_temp.bam -r ${Parent_A_ref} -pref F1_all_mapped_sort
mv F1_all_mapped_sort_temp.bam F1_all_mapped_sort.bam
#rm F1_all_mapped_sort_temp.bam
$samtools_PATH index F1_all_mapped_sort.bam
perl ../script/depth_calc_from_bam.pl F1_all_mapped_sort.bam $samtools_PATH
perl ../script/cover_ratio_from_bam.pl F1_all_mapped_sort.bam $samtools_PATH

Parent_A_self_bam=${work_dir}/Parent_A_self_alignment/Parent_A_all_mapped_sort.bam

perl ../script/4_select_pileup_file_without_indel.pl ${Parent_A_self_bam} F1_all_mapped_sort.bam ${Parent_A_ref} $samtools_PATH ${filtered_depth}
perl ../script/5_select_pileup_file_for_F1.pl Parent_A_vs_F1.pileup ${filtered_depth} ${filtered_snp_index}
line_nuber=`cat m_Parent_A_vs_F1.pileup|wc -l`
Rscript ../script/Fisher_test_for_F1_pileup_v2.R m_Parent_A_vs_F1.pileup ${line_nuber} ${defined_p_value}
perl  ../script/common_F1_simulation.pl ../simulation_result/F1_individuals.txt Fishire_test_m_Parent_A_vs_F1.pileup
