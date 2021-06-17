#!/usr/bin/perl -w
use strict;

my $bam_file_1= $ARGV[0]; #Parent_A bam file
my $bam_file_2= $ARGV[1]; #Parent_B F1 A bulk B bulk bam file
my $reference_fasta = $ARGV[2];
my $samtools_dir=$ARGV[3];
my $depht=$ARGV[4];
open (FILE1, "$samtools_dir mpileup -f $reference_fasta $bam_file_1 $bam_file_2|") or die "cannot open file";



my $bam_file_2_name=$bam_file_2;
$bam_file_2_name=~s/\S+\///;
$bam_file_2_name=~s/_all_mapped_sort.bam//;

my $out_put_file="Parent_A_vs_".$bam_file_2_name.".pileup";
my $out_put_indel_file=$out_put_file;
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

#######
    
    my $SNP_index=0;
	my $nucleotide_collum1=$colom[4];
    my $nucleotide_collum2=$colom[7];

    if($colom[3]>=$depht and $colom[6]>=$depht){
        if($nucleotide_collum2=~/\+\d+/ig or $nucleotide_collum2=~/\-\d+/ig){
            if($nucleotide_collum1!~/\+\d+/ig and $nucleotide_collum1!~/\-\d+/ig and $nucleotide_collum1!~/[ATGC]/ig){
                my $indel_collum2=$nucleotide_collum2;
                $indel_collum2=~s/[^\-\+]//ig;
                my $indel_number2=length($indel_collum2);
                my $indel_index2=$indel_number2/$colom[6];
                my $all_colom=join("\t",@colom);	
                my $wild_type_allel_num=$colom[6]-$indel_number2;
                print OUTPUT_indel "$all_colom\t$indel_index2\t$indel_number2\t$wild_type_allel_num\n";
            }
        }else{
    		if($nucleotide_collum1!~/[ATGC]/ig and $nucleotide_collum2=~/[ATGC]/ig){ #calclating snp index
        		$nucleotide_collum2=~s/[^ATGC]//ig;

                $nucleotide_collum2= uc $nucleotide_collum2;
                my $count_A = "A:".(() = $nucleotide_collum2=~ /A/g);
                my $count_T = "T:".(() = $nucleotide_collum2=~ /T/g);
                my $count_G = "G:".(() = $nucleotide_collum2=~ /G/g);
                my $count_C = "C:".(() = $nucleotide_collum2=~ /C/g);
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
			
			my $SNP_allel=length($nucleotide_collum2);
                $SNP_index=$SNP_allel/$colom[6];
				my $wild_type_allel=$colom[6]-$SNP_allel;
                $colom[3]=$SNP_nclu."\t".$colom[3];
                my $all_colom=join("\t",@colom);	

	    		
        		print OUTPUT "$all_colom\t$SNP_index\t$SNP_allel\t$wild_type_allel\n";

    		}
        }
	}
	#$count=$count+1;
    
}

close OUTPUT;
