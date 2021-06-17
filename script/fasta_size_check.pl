#!/usr/bin/perl

use strict;
use warnings;
my $fasta = $ARGV[0];

my $file_name=$fasta;
$file_name =~s/\S+\///;
$file_name=$file_name."_length.txt";
open (FILE1, $fasta) or die "cannot open file1";
open OUTPUT, ">$file_name\n" or die "cannnot open output";

###########################################################

my $chr_name ="";
my %chr_length = ();

while (<FILE1>){
    chomp;
    if ($_ =~ /^>/){
        $chr_name = $_;
        $chr_name =~ s/>//;
        $chr_length{$chr_name}=0;        
    }else{
        $chr_length{$chr_name} += length($_);
	next;
    }
}
close (FILE1);
#############################################################
my $Total_size=0;
foreach my $key_a (sort keys (%chr_length)){   
    print OUTPUT "$key_a:$chr_length{$key_a}\n";
    $Total_size=$Total_size+$chr_length{$key_a};
}

print OUTPUT "Total:$Total_size\n";
