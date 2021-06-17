#!/usr/bin/perl -w

#This program for qtl-seq

use strict;
my $Parent_B_snp_file = $ARGV[0];
my $bulk_snp_file = $ARGV[1];

open (FILE1, $Parent_B_snp_file ) or die "cannot open file";
open (FILE2, $bulk_snp_file ) or die "cannot open file";

$bulk_snp_file=~s/\S+\///;

open OUTPUT1, ">common_Parent_B_homo_snp_$bulk_snp_file\n" or die "cannot open file";
open OUTPUT2, ">rm_Parent_B_homo_snp_$bulk_snp_file\n" or die "cannot open file";
my %chr_position=();
while (my $genome = <FILE1>) {
    chomp $genome;
    my @colom1 = split (/\t/, $genome);
    my $all_colom1=join("\t",@colom1);
    $chr_position{$colom1[0]}{$colom1[1]}="common";
}
close (FILE1);


while (my $genome = <FILE2>) {
    chomp $genome;
    my @colom2 = split (/\s+/, $genome);
    my $all_colom2=join("\t",@colom2);
    if (exists $chr_position{$colom2[0]}{$colom2[1]}){       
	    print OUTPUT1 "$all_colom2\n";
    }else{
        print OUTPUT2 "$all_colom2\n";
    }
}


close(OUTPUT1);
close(FILE1);
close(FILE2);
