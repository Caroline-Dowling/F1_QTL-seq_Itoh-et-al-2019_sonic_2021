#!/usr/bin/perl -w
use strict;

my $bam_file = $ARGV[0];
my $reference_fasta = $ARGV[1];

my $samtools ="samtools.108";

open (FILE1, "/usr/local/bin/samtools mpileup -v -f $reference_fasta $bam_file|bcftools view -vcg|") or die "cannot open file";
####/usr/local/bin/samtools mpileup -f ${public_reference_fasta} Parent_A_all_mapped_sort.bam -v |bcftools view -S -cg -
###/usr/local/bin/samtools mpileup -f ${public_reference_fasta} Parent_A_all_mapped_sort.bam -v |/usr/local/bin/bcftools view -S -cg - | vcfutils.pl varFilter -D100>test.vcf
my $bam_file_name = $bam_file;
$bam_file_name =~s/\S+\///;
$bam_file_name =~s/.bam/.pileup/;

my $out_put_file=$bam_file_name;
open OUTPUT, ">$out_put_file\n" or die "cannot open file";


my $chr_name="";
my $out_put="";
my $on_off=0;

while (my $file = <FILE1>) {
    chomp $file;
    
    print "$file\n";
    my @colom = split (/\t+/, $file);
    my $all_colom=join("\t",@colom);
    my $SNP_index=0;

    
    if($colom[8]=~/[ATGC]/ig and $colom[2]!~/\*/){ #calclating snp index
        $colom[8]=~s/[^ATGC]//ig;
        my $SNP_allel=length($colom[8]);
	    $SNP_index=$SNP_allel/$colom[7];
        print OUTPUT "$all_colom\t$SNP_index\n";
    } 

    
}

close OUTPUT;
