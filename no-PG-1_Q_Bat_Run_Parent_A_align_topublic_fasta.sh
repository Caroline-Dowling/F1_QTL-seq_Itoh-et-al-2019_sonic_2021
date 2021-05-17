#! /bin/sh	
#$ -S /bin/sh
#$ -cwd
#/usr/local/bin/samtools Version: 1.3.1 (using htslib 1.3.1)
#BWA Version: 0.7.12-r1039
#Please confirm the read information files
public_reference_fasta=/home/people/15402172/scratch/QTL-seq_v2_test_sonic_19-04-2021/Brap_refseq.fna
used_cpu=4
samtools_PATH=/opt/software/samtools/1.10/bin/samtools
bwa_PATH=/opt/software/bwa/0.7/bin/bwa
filtered_mapping_score_in_bam=10

#developing Parent_A ref
filtered_depth=9
the_snp_index_threshold_for_exchanging_with_public_ref=1

#--------------------------------------------------------------------------------------------------------


work_dir=`pwd`
chmod +x -R $work_dir/*


#developing pubulic fasta index################################################
public_reference_fasta_name=`echo ${public_reference_fasta}|sed -e "s/.*\\///"`
mkdir public_fasta
cd public_fasta
ln -s ${public_reference_fasta}
public_reference=${public_reference_fasta_name}
${bwa_PATH} index -p ${public_reference} -a bwtsw ${public_reference}
cd ../
#-----------------------------------------------------------------------


mkdir Parent_A_ref_seq_development
cd Parent_A_ref_seq_development
perl ../script/making_bwa_format_for_parental_line.pl ${work_dir}/read_information/Parent_A_reads.txt ${work_dir}/public_fasta/${public_reference} ${bwa_PATH} ${samtools_PATH}

chmod +x *
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

# fix read group errors in ValidateSamFile
java -jar $PICARD AddOrReplaceReadGroups \I=Parent_A_all_temp.bam \O=RG_Parent_A_all_temp.bam \RGID=4 \RGLB=lib1 \RGPL=illumina \RGPU=unit1 \RGSM=20
# rename RG bam to old bam name to avoid discrepancies in the code downstream
rm Parent_A_all_temp.bam
mv RG_Parent_A_all_temp.bam Parent_A_all_temp.bam

# fix PG line error in samtools view
$samtools_PATH reheader -P -c 'grep -v ^@PG' Parent_A_all_temp.bam > PG_corrected_Parent_A_all_temp.bam
# rename PG corrected bam to old bam name to avoid discrepancies in the code downstream
rm Parent_A_all_temp.bam
mv PG_corrected_Parent_A_all_temp.bam Parent_A_all_temp.bam

perl ../script/bam_filter.pl Parent_A_all_temp.bam ${filtered_mapping_score_in_bam} $samtools_PATH

$samtools_PATH sort --no-PG -T Parent_A_temp -@ ${used_cpu} f_Parent_A_all_temp.bam -o Parent_A_all_merge.bam
rm Parent_A_temp*.bam
rm Parent_A_all_temp.bam

$samtools_PATH rmdup Parent_A_all_merge.bam Parent_A_all_merge_rmdup.bam
$samtools_PATH view --no-PG -b -f 4 Parent_A_all_merge_rmdup.bam > Parent_A_all_unmapped.bam
$samtools_PATH view --no-PG -b -F 4 Parent_A_all_merge_rmdup.bam > Parent_A_all_mapped.bam
$samtools_PATH sort --no-PG -T Parent_A_temp -@ ${used_cpu} Parent_A_all_mapped.bam -o Parent_A_all_mapped_sort.bam
$samtools_PATH index Parent_A_all_mapped_sort.bam

perl ../script/snp_index_calc_from_pileup_without_index.pl Parent_A_all_mapped_sort.bam ${public_reference_fasta} $samtools_PATH
perl ../script/select_pileup_file.pl Parent_A_all_mapped_sort.pileup ${filtered_depth} ${the_snp_index_threshold_for_exchanging_with_public_ref}
perl ../script/make_consensus.pl -ref ${public_reference_fasta} m_Parent_A_all_mapped_sort.pileup >Parent_A_ref.fa

${bwa_PATH} index -p Parent_A_ref.fa -a bwtsw Parent_A_ref.fa

cd $work_dir
mkdir all_log_files
mv log_file* all_log_files
