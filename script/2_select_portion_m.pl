#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $threshold_depth = $ARGV[1];
my $threshold_snp_index = $ARGV[2];
open (FILE, $genome_file) or die "cannot open file";

$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;

my $threshold_snp_index_rm=1-$threshold_snp_index;
my$name_SNParent_A="./select_D_".$threshold_depth."_S_".$threshold_snp_index."_and_".$threshold_snp_index_rm."_".$genome_file;

open OUTPUT1, ">$name_SNParent_A\n" or die "cannot open file";



while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);
    my $colom_all =join("\t",@colom);
    
    if ($colom[3]>=$threshold_depth and  $colom[5]>=$threshold_depth){
        if ($colom[4]>=$threshold_snp_index or  $colom[6]>=$threshold_snp_index){
            if ($colom[4]<=$threshold_snp_index_rm or  $colom[6]<=$threshold_snp_index_rm){

                print OUTPUT1  $colom_all, "\n";   
            }
        }
    }
    
}

close(OUTPUT1);
close(FILE);
 
