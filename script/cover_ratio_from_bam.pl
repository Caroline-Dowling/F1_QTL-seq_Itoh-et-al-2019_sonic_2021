#!/usr/bin/perl -w
use strict;

my $bam_file= $ARGV[0]; #bam file
my $samtools_dir=$ARGV[1];

open (FILE1, "$samtools_dir depth $bam_file -a|") or die "cannot open file";



my $bam_file_name=$bam_file;
$bam_file_name=~s/\S+\///;
$bam_file_name=~s/.bam/_cover_ratio.txt/;

my $out_put_file=$bam_file_name;
open OUTPUT, ">$out_put_file\n" or die "cannot open file";


my %chr_depth_over_1=();
my %chr_length=();
while (my$file = <FILE1>) {
    chomp $file;
    my @colom = split (/\t+/, $file);
    if ($colom[2]>=1){
        $chr_depth_over_1{$colom[0]} +=1;
    }
	$chr_length{$colom[0]} +=1;


}
#######


foreach my $key_a (sort {$a cmp $b} keys(%chr_depth_over_1)){
	my $cvoer_ratio= $chr_depth_over_1{$key_a}/$chr_length{$key_a};
	print OUTPUT "$key_a\t$cvoer_ratio\n";      
}
