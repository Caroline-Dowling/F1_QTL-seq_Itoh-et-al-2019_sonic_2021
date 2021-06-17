#!/usr/bin/perl -w
use strict;

my $genome_file = $ARGV[0];
my $simulation_file=$ARGV[1];


$genome_file=~s/\.\.\///;
print $genome_file,"\n";
$genome_file=~s/\S+\///;
my$name_SNP="./s_".$genome_file;


open OUTPUT1, ">$name_SNP\n" or die "cannot open file";



open (FILE2, $simulation_file) or die "cannot open file";
my %depth=();
my %depth_Short=();
my %depth_Tall=();
while (my $genome = <FILE2>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);
    my $depht=$colom[0];
    
    my @delta_colom = splice (@colom, 1,4);
    my @delta_colom_Short = splice (@colom, 1,4);
    my @delta_colom_Tall = splice (@colom, 1,4);
    
    my $delta_colom_all =join("\t",@delta_colom);
    my $delta_colom_Short =join("\t",@delta_colom_Short);
    my $delta_colom_Tall =join("\t",@delta_colom_Tall);
    
    $depth{$depht}=$delta_colom_all;
    $depth_Short{$depht}=$delta_colom_Short;
    $depth_Tall{$depht}=$delta_colom_Tall;
}


my $line=1;

open (FILE, $genome_file) or die "cannot open file";
while (my $genome = <FILE>) {
    chomp $genome;
    my @colom = split (/\t+/, $genome);

    if($line==1){
        my $colom_all =join("\t",@colom);
        $line=2
    }else{
        my $caluclate=$colom[3]-$colom[5];
        my $depth=0;
        if($caluclate>0){
             $depth=$colom[5]
        }else{
            $depth=$colom[3]
        }
        my $colom_all =join("\t",@colom);
        print OUTPUT1   "$colom_all\t$depth{$depth}\t$depth_Short{$colom[3]}\t$depth_Tall{$colom[5]}\t$depth{$depth}\n"; 
    }
}

close(OUTPUT1);
close(FILE);
 
