
##############################################################
Arg<-commandArgs(T)  #
TAB_file<-Arg[1]
window_size<-Arg[2]
step<-Arg[3]
howmany_snp_number<-Arg[4]
##############################################################


#mapping_quality<-40
options(scipen=100)
DATA_1<-read.table(TAB_file, header=F, as.is=TRUE, quote="", comment.char="", sep="\t")

window_size<-as.numeric(window_size)+0
step<-as.numeric(step)+0
howmany_snp_number<-as.numeric(howmany_snp_number)+0
window_size_print<-window_size/1000000

sortlist <- order(DATA_1$V1, pmax(DATA_1$V1, DATA_1$V2)) 
DATA_1 <-DATA_1[order(DATA_1$V1, DATA_1$V2),] 
chromosome<-unique(DATA_1$V1)
TAB_file <-sub("\\S+/","", TAB_file)
out_put<-paste("./sliding_window_", window_size_print,"_Mb_",TAB_file,sep="")

on_off<-0

for(chr_num in chromosome){
	print (chr_num)
	DATA_1_M<-DATA_1[DATA_1$V1==chr_num,]
	max_position_of_chr<-max(DATA_1_M$V2)
	max_value<-(max_position_of_chr-window_size/2)
	window_start<-seq(window_size/2*-1,max_value, by=step)
	
	for(key_a in window_start){
		
		DATA_1_M_AV<-DATA_1_M[DATA_1_M$V2>=key_a & DATA_1_M$V2<=key_a+window_size,]
		position<-c(key_a+window_size/2)
		nrow_number<-nrow(DATA_1_M_AV)
		if(nrow_number > howmany_snp_number){
			mean_SNP_index_a<-mean(DATA_1_M_AV$V5)
			mean_SNP_index_b<-mean(DATA_1_M_AV$V7)
			mean_SNP_index_D<-mean(DATA_1_M_AV$V5-DATA_1_M_AV$V7)
			mean_95_l<-mean(DATA_1_M_AV$V8)
			mean_95_u<-mean(DATA_1_M_AV$V9)
			mean_99_l<-mean(DATA_1_M_AV$V10)
			mean_99_u<-mean(DATA_1_M_AV$V11)
			mean_95_l_Short<-mean(DATA_1_M_AV$V12)
			mean_95_u_Short<-mean(DATA_1_M_AV$V13)
			mean_99_l_Short<-mean(DATA_1_M_AV$V14)
			mean_99_u_Short<-mean(DATA_1_M_AV$V15)
			mean_95_l_Tall<-mean(DATA_1_M_AV$V16)
			mean_95_u_Tall<-mean(DATA_1_M_AV$V17)
			mean_99_l_Tall<-mean(DATA_1_M_AV$V18)
			mean_99_u_Tall<-mean(DATA_1_M_AV$V19)
						
			print_vector<-c(chr_num, position, mean_SNP_index_a, mean_SNP_index_b, mean_SNP_index_D,mean_95_l,mean_95_u,mean_99_l,mean_99_u, mean_95_l_Short, mean_95_u_Short, mean_99_l_Short, mean_99_u_Short, mean_95_l_Tall, mean_95_u_Tall, mean_99_l_Tall, mean_99_u_Tall)		
			if(on_off==0){
				write(t(print_vector), out_put, append=F,sep="\t", ncolumns=length(print_vector))
				on_off=1
			}else{
				write(t(print_vector), out_put, append=T,sep="\t", ncolumns=length(print_vector))
			}
		}
	}	
}	




