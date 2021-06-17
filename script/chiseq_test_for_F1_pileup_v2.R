
##############################################################
Arg<-commandArgs(TRUE)
data_snp<-c(Arg[1])
line_number<-c(Arg[2])
test_depth<-c(Arg[3])
##############################################################
f<-file(data_snp,"r")
segregation_ratio<-c(1,1)
segregation_ratio_p<-segregation_ratio/sum(segregation_ratio)
data_snp <-sub("\\S+/","", data_snp)
out_put<-paste("./chiseq_", data_snp,sep="")
test_depth<-as.numeric(test_depth)
on_off<-0
for(i in 1:line_number){
    a<-readLines(con=f,1)
    v<-as.vector(strsplit(a,"\t")[[1]])
	v_8<-as.numeric(v[8])
	v_12<-as.numeric(v[12])
	v_13<-as.numeric(v[13])
	test_number<-c(v_12,v_13)


	

	
		if(v_12>0 & v_13>0 & v_8>test_depth){

			p_value<-chisq.test(test_number,p= segregation_ratio_p)$p.value
	
			if (p_value>=0.05){
				print_vector<-c(v, p_value)		
				if(on_off==0){
					write(t(print_vector), out_put, append=F,sep="\t", ncolumns=length(print_vector))
					on_off=1
				}else{
					write(t(print_vector), out_put, append=T,sep="\t", ncolumns=length(print_vector))
				}	
			}  
		}

}

warnings() 
