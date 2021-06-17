#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $threshold_depht=$ARGV[1];
open (FILE, $genome_file) or die "cannot open file";

$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;


my$name_SNParent_A="./m_".$genome_file;
open OUTPUT1, ">$name_SNParent_A\n" or die "cannot open file";


while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);
    my $colom_all =join("\t",@colom);

    if ($colom[4]>=$threshold_depht and $colom[7]>=$threshold_depht and $colom[10]<1){
        print OUTPUT1  $colom_all, "\n"; 

    }
}

close(OUTPUT1);
close(FILE);
 
