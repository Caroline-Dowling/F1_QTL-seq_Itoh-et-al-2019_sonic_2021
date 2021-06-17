#!/usr/bin/perl -w
use strict;

my $bam_file_1= $ARGV[0]; #Parent_A bam file
my $bam_file_2= $ARGV[1]; #Short bam file
my $bam_file_3= $ARGV[2]; #Tall bam file
my $reference_fasta = $ARGV[3];
my $samtools_dir=$ARGV[4];
my $depht=$ARGV[5];
open (FILE1, "$samtools_dir mpileup -f $reference_fasta $bam_file_1 $bam_file_2 $bam_file_3|") or die "cannot open file";



my $bam_file_2_name=$bam_file_2;
$bam_file_2_name=~s/\S+\///;
$bam_file_2_name=~s/_all_mapped_sort.bam//;

my $out_put_file="Parent_A_Short_Tall.pileup";
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
    my $nucleotide_collum3=$colom[10];
    # if($colom[3]>=$depht and $colom[6]>=$depht and $colom[9]>=$depht){
    if($colom[6]>=$depht and $colom[9]>=$depht){
        if($nucleotide_collum1=~/\+\d+/ig or $nucleotide_collum1=~/\-\d+/ig or $nucleotide_collum2=~/\+\d+/ig or $nucleotide_collum2=~/\-\d+/ig or $nucleotide_collum3=~/\+\d+/ig or $nucleotide_collum3=~/\-\d+/ig){
			my $indel_collum1=$nucleotide_collum1;
			$indel_collum1=~s/[^\-\+]//ig;
			my $indel_number1=length($indel_collum1);
			my $indel_index1=$indel_number1/$colom[6];
			my $indel_collum2=$nucleotide_collum2;
			$indel_collum2=~s/[^\-\+]//ig;
			my $indel_number2=length($indel_collum2);
			my $indel_index2=$indel_number2/$colom[9];            
    
            print OUTPUT_indel "$colom[0]\t$colom[1]\t$colom[2]\t$colom[3]\tI\t$colom[6]\t$indel_index1\tI\t$colom[9]\t$indel_index2\n";
            
        }else{
        
        
        
        
    		# if($nucleotide_collum1!~/[ATGC]/ig) { #calclating snp index
    
                if($colom[7]=~/[ATGC]/ig or $colom[10]=~/[ATGC]/ig){

                    my $nucleotide_collum2_data="";
                    if($nucleotide_collum2=~/[ATGC]/ig){

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
                        if($SNP_nclu_count>1){ 
                            $nucleotide_collum2_data="Tri\t".$colom[6]."\t999";
                        }else{
                            my $SNP_allel=length($nucleotide_collum2);
                            $SNP_index=$SNP_allel/$colom[6];
                            $nucleotide_collum2_data=$SNP_nclu."\t".$colom[6]."\t".$SNP_index;
                        }                        
                    }else{
                        $nucleotide_collum2_data=$colom[2]."\t".$colom[6]."\t0";
                    }
                   
                   
                    my $nucleotide_collum3_data="";
                    if($nucleotide_collum3=~/[ATGC]/ig){
                        $nucleotide_collum3=~s/[^ATGC]//ig;			
                        $nucleotide_collum3= uc $nucleotide_collum3;  
                        my $count_A = "A:".(() = $nucleotide_collum3=~ /A/g);
                        my $count_T = "T:".(() = $nucleotide_collum3=~ /T/g);
                        my $count_G = "G:".(() = $nucleotide_collum3=~ /G/g);
                        my $count_C = "C:".(() = $nucleotide_collum3=~ /C/g);
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

                        if($SNP_nclu_count>1){ 
                            $nucleotide_collum3_data="Tri\t".$colom[9]."\t999";
                        }else{
                            my $SNP_allel=length($nucleotide_collum3);
                            $SNP_index=$SNP_allel/$colom[9];
                            $nucleotide_collum3_data=$SNP_nclu."\t".$colom[9]."\t".$SNP_index;
                        }                        
                    }else{
                        $nucleotide_collum3_data=$colom[2]."\t".$colom[9]."\t0";
                    }

                    print OUTPUT "$colom[0]\t$colom[1]\t$colom[2]\t$colom[3]\t$nucleotide_collum2_data\t$nucleotide_collum3_data\n";
                }
    		# }
        }
	}
	#$count=$count+1;
    
}

close OUTPUT;
