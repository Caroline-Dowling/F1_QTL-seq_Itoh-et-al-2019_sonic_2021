#!/usr/bin/perl -w

#This program for qtl-seq

use strict;
my $F1_imulation = $ARGV[0];
my $F1_pileup_file = $ARGV[1];

open (FILE1, $F1_imulation ) or die "cannot open file";
open (FILE2, $F1_pileup_file ) or die "cannot open file";

$F1_pileup_file=~s/\S+\///;

open OUTPUT1, ">sim_$F1_pileup_file\n" or die "cannot open file";

my %chr_position=();
while (my $genome = <FILE1>) {
    chomp $genome;
    my @colom1 = split (/\t/, $genome);
    my $all_colom1=join("\t",@colom1);
    $chr_position{$colom1[0]}=$all_colom1;
}
close (FILE1);


while (my $genome = <FILE2>) {
    chomp $genome;
    my @colom2 = split (/\s+/, $genome);
    my $all_colom2=join("\t",@colom2);
    if (exists $chr_position{$colom2[4]}){
	    my @colom_confidence_inerval = split (/\s+/, $chr_position{$colom2[4]});
	    my $confidence_95_l=$colom_confidence_inerval[1];
	    my $confidence_95_h=$colom_confidence_inerval[2];
	    
	    if ($colom2[10]>$confidence_95_l and $colom2[10]<$confidence_95_h ) {
		print OUTPUT1 "$all_colom2\n";
	    }
	    
	    
    }
}


close(OUTPUT1);
close(FILE1);
close(FILE2);
