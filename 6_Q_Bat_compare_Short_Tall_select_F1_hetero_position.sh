#! /bin/sh	
#$ -S /bin/sh
#$ -cwd

# qsub -N log_file -pe def_slot 2 -l s_vmem=15G -l mem_req=15G -l month ./Q_Bat_Run.sh
used_cpu=4
samtools_PATH=/opt/software/samtools/1.10/bin/samtools
filtered_depth=9

window_size_Mb=2
step_size_kb=50
howmany_snp_number=10

individual_number=20
population_structure=F2
#---------------------------------
filtered_both_false_snp_index=0

work_dir=`pwd`
chmod +x -R $work_dir/*


F1_hetero_pileup=${work_dir}/F1_to_Parent_A_alignment/sim_Fishire_test_m_Parent_A_vs_F1.pileup

filtered_bulk_pileup=${work_dir}/compare_Short_Tall/Parent_A_Short_Tall.pileup


mkdir compare_Short_Tall_select_F1_hetero_SNP
cd compare_Short_Tall_select_F1_hetero_SNP

perl ../script/10_common_position_select.pl ${F1_hetero_pileup} ${filtered_bulk_pileup}
perl ../script/6_select_pileup_file.pl common_F1_hetero_snp_Parent_A_Short_Tall.pileup ${filtered_depth} ${filtered_both_false_snp_index}

perl ../script/6_s_add_simulation.pl m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup ../simulation_result/${population_structure}_${individual_number}_individuals.txt

# Plot only chr as contigs squash plots
grep 'NC_024804.2\|NC_024795.2\|NC_024796.2\|NC_024797.2\|NC_024798.2\|NC_024799.2\|NC_024800.2\|NC_024801.2\|NC_024803.2\|NC_024802.2' s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup > chr_only.pileup
rm s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup
mv chr_only.pileup s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup

Rscript ../script/7_QTLseq_sliding_window_170321.R s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup ${window_size_Mb}000000 ${step_size_kb}000 ${howmany_snp_number}
Rscript ../script/8_MutMap_graph_bulkA.R s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup
Rscript ../script/8_MutMap_graph_bulkB.R s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup
Rscript ../script/8_MutMap_graph_bulkD.R s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup sliding_window_${window_size_Mb}_Mb_s_m_common_F1_hetero_snp_Parent_A_Short_Tall.pileup



cd ../



