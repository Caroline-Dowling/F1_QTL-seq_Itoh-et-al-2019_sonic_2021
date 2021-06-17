#!/usr/bin/perl -w
use strict;

my $bam_file = $ARGV[0];
my $reference_fasta = $ARGV[1];
my $samtools_dir=$ARGV[2];

open (FILE1, "$samtools_dir mpileup -f $reference_fasta $bam_file|") or die "cannot open file";
####/usr/local/bin/samtools mpileup -f ${public_reference_fasta} hinona_all_mapped_sort.bam -v |bcftools view -S -cg -
###/usr/local/bin/samtools mpileup -f ${public_reference_fasta} hinona_all_mapped_sort.bam -v |/usr/local/bin/bcftools view -S -cg - | vcfutils.pl varFilter -D100>test.vcf
my $bam_file_name = $bam_file;
$bam_file_name =~s/\S+\///;
$bam_file_name =~s/.bam/.pileup/;

my $out_put_file=$bam_file_name;
my $out_put_indel_file=$bam_file_name;
$out_put_indel_file=~s/.pileup/_indel.pileup/;
open OUTPUT, ">$out_put_file\n" or die "cannot open file";
open OUTPUT_indel, ">$out_put_indel_file\n" or die "cannot open file";

my $chr_name="";
my $out_put="";
my $on_off=0;
my $count=1;
while (my $file = <FILE1>) {
    chomp $file;
    my @colom = split (/\t+/, $file);
    my $SNP_index=0;
	my $nucleotide_collum=$colom[4];
    if($colom[3]>0){
        
        if($nucleotide_collum=~/\+\d+/ig or $nucleotide_collum=~/\-\d+/ig){
			my $all_colom_indel=join("\t",@colom);	
			my $indel_collum=$colom[4];
			$indel_collum=~s/[^\-\+]//ig;
			my $indel_number=length($indel_collum);
			my $indel_index=$indel_number/$colom[3];
			print OUTPUT_indel "$all_colom_indel\t$indel_index\n";
            
        }else{
 

    		if($nucleotide_collum=~/[ATGC]/ig){ #calclating snp index
        		$nucleotide_collum=~s/[^ATGC]//ig;
                $nucleotide_collum= uc $nucleotide_collum;
                my $count_A = "A:".(() = $nucleotide_collum=~ /A/g);
                my $count_T = "T:".(() = $nucleotide_collum=~ /T/g);
                my $count_G = "G:".(() = $nucleotide_collum=~ /G/g);
                my $count_C = "C:".(() = $nucleotide_collum=~ /C/g);
                my @nucl_array=($count_A, $count_T, $count_G, $count_C);
                my $SNP_nclu="";
                my $SNP_nclu_count=0;
                my $max_allel=0;
                foreach my $key_a (@nucl_array){
                    my @key_a_array=split(/:/,$key_a);
                    if($max_allel<$key_a_array[1]){
                        $max_allel=$key_a_array[1];
                        $SNP_nclu=$key_a_array[0];
                    }

                    if($key_a_array[1]>0){
                        $SNP_nclu_count=$SNP_nclu_count+1;
                    }
                }

                my $SNP_allel=length($nucleotide_collum);
                $SNP_index=$SNP_allel/$colom[3];
                $colom[3]=$SNP_nclu."\t".$colom[3];
                my $all_colom=join("\t",@colom);	
                print OUTPUT "$all_colom\t$SNP_index\n";

            }
        }
    }
	#$count=$count+1;
}

close OUTPUT;
