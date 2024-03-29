#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $threshold_depht=$ARGV[1];
my $threshold_snp_index=$ARGV[2];
open (FILE, $genome_file) or die "cannot open file";

$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;


my$name_SNParent_A="./m_".$genome_file;
open OUTPUT1, ">$name_SNParent_A\n" or die "cannot open file";


while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);

    if ($colom[6]<999 and $colom[9]<999 and $colom[5]>$threshold_depht and $colom[8]>$threshold_depht and $colom[5]<300 and $colom[8]<300){  ###without triallelic position
		if($colom[6]>$threshold_snp_index or $colom[9]>$threshold_snp_index){
			if($colom[6]<=1 or $colom[9]<=1){
				print OUTPUT1 "$colom[0]\t$colom[1]\t$colom[3]\t$colom[5]\t$colom[6]\t$colom[8]\t$colom[9]\n"; 
			}
		}
        

    }
}

close(OUTPUT1);
close(FILE);
 
