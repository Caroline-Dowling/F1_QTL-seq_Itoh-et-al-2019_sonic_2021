#!/usr/bin/perl

use strict;
use warnings;
my $Parent_B_reads_txt = $ARGV[0];
my $ref_fasta = $ARGV[1];
my $bwa_path = $ARGV[2];
my $samtools_path = $ARGV[3];
my $Parent_B_reads_txt_rename=$Parent_B_reads_txt;
$Parent_B_reads_txt_rename=~s/\S+\///;

my $ref_fasta_name=$ref_fasta;
$ref_fasta_name=~s/\S+\///;
my $simbolic_link_txt="ex_for_link_".$Parent_B_reads_txt_rename;
open OUTPUT_link, ">$simbolic_link_txt\n" or die "cannnot open output";
print OUTPUT_link "ln -snf $bwa_path links/bwa\n";
print OUTPUT_link "ln -snf $samtools_path links/samtools\n";

my $Parent_B_reads_txt_rename1="ex_for_alignment_".$Parent_B_reads_txt_rename;
my $Parent_B_reads_txt_rename2="ex_for_sam_development_".$Parent_B_reads_txt_rename;
my $Parent_B_reads_txt_rename3="ex_for_bam_development_".$Parent_B_reads_txt_rename;
open OUTPUT1, ">$Parent_B_reads_txt_rename1\n" or die "cannnot open output";
open OUTPUT2, ">$Parent_B_reads_txt_rename2\n" or die "cannnot open output";
open OUTPUT3, ">$Parent_B_reads_txt_rename3\n" or die "cannnot open output";
open (FILE1, $Parent_B_reads_txt) or die "cannot open file1";

###########################################################
my $read_count=0;
while (my $file = <FILE1>) {
    chomp $file;
print "$read_count\n";
    if ($file =~ /^#/){
        
    }else{
		
        $read_count=$read_count+1;
        my @colom1 = split (/\s+/, $file);
        
 
        print OUTPUT_link "ln -snf $colom1[0] links/${read_count}_1.fastq\n";
        print OUTPUT_link "ln -snf $colom1[1] links/${read_count}_2.fastq\n";

        print OUTPUT1 "links/bwa aln ../Parent_A_ref_seq_development/Parent_A_ref.fa links/${read_count}_1.fastq >Parent_B_temp_${read_count}_1.sai\n";
        print OUTPUT1 "links/bwa aln ../Parent_A_ref_seq_development/Parent_A_ref.fa links/${read_count}_2.fastq >Parent_B_temp_${read_count}_2.sai\n";
        print OUTPUT2 "links/bwa sampe ../Parent_A_ref_seq_development/Parent_A_ref.fa Parent_B_temp_${read_count}_1.sai Parent_B_temp_${read_count}_2.sai links/${read_count}_1.fastq links/${read_count}_2.fastq>Parent_B_temp_${read_count}.sam\n";
        print OUTPUT3 "links/samtools view -bS Parent_B_temp_${read_count}.sam> Parent_B_temp_${read_count}.bam\n";
    }
}
close (FILE1);
#############################################################


