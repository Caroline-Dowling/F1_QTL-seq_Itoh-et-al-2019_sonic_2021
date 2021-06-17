#!/usr/bin/perl -w
use strict;
my $bam_file = $ARGV[0];
my $filtere_quality=$ARGV[1];
# my $filtere_insert=$ARGV[2];
my $samtools_dir=$ARGV[2];

open (FILE1, "$samtools_dir view -h $bam_file| ") or die "cannot open file";

my $bam_file_name = $bam_file;
$bam_file_name =~s/\S+\///;
$bam_file_name="f_".$bam_file_name;

open(OUTPUT, "|$samtools_dir view -bS -o $bam_file_name - ") or die "hogehoge";

while (my $file1 = <FILE1>) {
    chomp $file1;
    my @colom = split (/\s+/, $file1);
    my $all_colom=join("\t",@colom);
    if($colom[0]=~/^@/){
		print OUTPUT "$all_colom\n";
    }else{
        if ($colom[4]>=$filtere_quality) {
            # if ($colom[8]<$filtere_insert){
                print OUTPUT "$all_colom\n";
            # }
        }
    }
}



close(FILE1);
close(OUTPUT);

