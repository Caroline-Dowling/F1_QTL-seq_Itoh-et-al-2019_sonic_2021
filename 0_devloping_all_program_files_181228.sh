#! /bin/sh	
#$ -S /bin/sh
#$ -cwd
used_cpu=4
samtools_PATH="/opt/software/samtools/1.10/bin/samtools"
bwa_PATH="/opt/software/bwa/0.7/bin/bwa"
P1_name="Parent_A"
P2_name="Parent_B"
A_bulk_name="Short"
B_bulk_name="Tall"

public_ref="/home/people/15402172/scratch/QTL-seq_v2_test_sonic_19-04-2021/Brap_refseq.fna"
filtered_depth=9
the_snp_index_threshold_for_exchanging_with_public_ref=1

individual_number=20
reprication=10000
population_structure=F2 #F2 or RIL

filtered_mapping_score_in_bam=10
filtered_insert_size_in_bam=10000

window_size_Mb=2
step_size_kb=50
howmany_snp_number=10
#----------------------------------------
#———————————————————————————————————————————————

for munber_name in ${P1_name} ${P2_name} ${A_bulk_name} ${B_bulk_name}
do
    if echo ${munber_name} | grep ^[0-9] ; then
      echo "Change sample name.　The use of numeric charactor must be avoided at the first character for sample name."
      exit
    fi
done

if echo ${P1_name} | grep -e 'P2' -e 'A_bulk' -e 'B_bulk' ; then
  echo "You need to change 'P1_name'. Remove the charactor 'P2' or 'A_bulk' or 'B_bulk' from P1_name."
  exit
fi

if echo ${P2_name} | grep -e 'A_bulk' -e 'B_bulk' ; then
  echo "You need to change 'P2_name'. Remove the charactor 'A_bulk' or 'B_bulk' from P2_name."
  exit
fi

if echo ${A_bulk_name} | grep 'B_bulk' ; then
  echo "You need to change 'A_bulk_name'. Remove the charactor 'B_bulk' from A_bulk_name."
  exit
fi







#———————————————————————————————————————————————

work_dir=`pwd`

perl original_scripts/script/fasta_size_check.pl ${public_ref}
fata_name=`echo ${public_ref}|sed -e "s/.*\\///"`
fasta_length=${work_dir}/${fata_name}_length.txt
test_length=`cat ${fasta_length} |awk 'END{print}'|sed -e "s/Total://"`

bwa_option1=is
if test ${test_length} -gt 300000000 ; then
  bwa_option1=bwtsw
fi


Bat_files=`ls original_scripts/Bat_file`
for each_Bat_files in $Bat_files
do
     echo $each_Bat_files
     perl original_scripts/devloping_all_program_files/0_rename_bat_file.pl original_scripts/Bat_file/$each_Bat_files ${work_dir} $P1_name $P2_name $A_bulk_name $B_bulk_name $public_ref $used_cpu $samtools_PATH $filtered_depth $the_snp_index_threshold_for_exchanging_with_public_ref $bwa_option1 $bwa_PATH $individual_number $reprication $population_structure $window_size_Mb $step_size_kb $howmany_snp_number $filtered_mapping_score_in_bam
done


mkdir script

script_files=`ls original_scripts/script`
for each_script_files in $script_files
do
     echo $each_script_files
     perl original_scripts/devloping_all_program_files/0_rename_file.pl original_scripts/script/$each_script_files ${work_dir}/script $P1_name $P2_name $A_bulk_name $B_bulk_name $public_ref $used_cpu $samtools_PATH $filtered_depth $the_snp_index_threshold_for_exchanging_with_public_ref $bwa_option1 $bwa_PATH
done

mkdir read_information
perl original_scripts/devloping_all_program_files/0_developing_read_information.pl read_PATH.txt ${work_dir}/read_information $P1_name $P2_name $A_bulk_name $B_bulk_name


chmod +x *.sh

