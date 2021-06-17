#!/usr/bin/perl -w
use strict;

my $bam_file_1= $ARGV[0]; #Parent_A bam file
my $bam_file_2= $ARGV[1]; #A bulk

my $reference_fasta = $ARGV[2];
my $samtools_dir=$ARGV[3];
my $depht=$ARGV[4];
open (FILE1, "$samtools_dir mpileup -f $reference_fasta $bam_file_1 $bam_file_2|") or die "cannot open file";



my $bam_file_2_name=$bam_file_2;
$bam_file_2_name=~s/\S+\///;
$bam_file_2_name=~s/_all_mapped_sort.bam//;

my $out_put_file1="Parent_A_${bam_file_2_name}_large_indel.pileup";
my $out_put_file2="${bam_file_2_name}_Parent_A_large_indel.pileup";
open OUTPUT, ">$out_put_file1\n" or die "cannot open file";
open OUTPUT2, ">$out_put_file2\n" or die "cannot open file";
print OUTPUT "chr\tposition\tParent_A_depth\t${bam_file_2_name}_depth\n";
print OUTPUT2 "chr\tposition\tParent_A_depth\t${bam_file_2_name}_depth\n";
while (my $file = <FILE1>) {
    chomp $file;
    my @colom = split (/\t+/, $file);

#######  
    my $SNP_index=0;
    if($colom[3]==0 and $colom[6]>=$depht){
        print OUTPUT "$colom[0]\t$colom[1]\t$colom[3]\t$colom[6]\n";
	}

    if($colom[3]>=$depht and $colom[6]==0){
       print OUTPUT2 "$colom[0]\t$colom[1]\t$colom[3]\t$colom[6]\n";
	}
    
}


close OUTPUT;
