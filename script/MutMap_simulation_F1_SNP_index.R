###########SNP_index_caluclation#########################

snp_index<-function(read_depth,ratio_of_genotype_in_the_population){
	x1<-rbinom(1,read_depth,ratio_of_genotype_in_the_population)
	return(x1/read_depth)	
}


###########input###############################################
reprication<-10000
depth_analysis<-c(1:300)
###########input###############################################


depth_data<-c()
p_h_data_95<-c()
p_l_data_95<-c()
p_h_data_99<-c()
p_l_data_99<-c()
for (key_depth in depth_analysis){
	print(key_depth)
	depth_data<-c(depth_data,key_depth)
	depth<-key_depth
    sum_snp_index<-c()    
	for(i in 1:reprication){    
        ##########gene_frequency######################
		ratio_of_genotype_in_the_population<-0.5
		a_snp_index<-snp_index(key_depth,ratio_of_genotype_in_the_population)		
		sum_snp_index<-c(sum_snp_index,a_snp_index)		
		##########gene_frequency######################
	}
	order_sum_snp_index<-sort(sum_snp_index)
	length_sum_snp_index<-length(sum_snp_index)

	##########snp_index_probabirity_0.05######################       
	snp_cutoff_up_0.95<-order_sum_snp_index[ceiling(0.95*length_sum_snp_index)]
	snp_cutoff_up_0.05<-order_sum_snp_index[ceiling(0.05*length_sum_snp_index)]
    p_h_data_95<-c(p_h_data_95,snp_cutoff_up_0.95) 
    p_l_data_95<-c(p_l_data_95,snp_cutoff_up_0.05)   
	##########snp_index_probabirity_0.05######################
        
	##########snp_index_probabirity_0.01######################        
	snp_cutoff_up_0.99<-order_sum_snp_index[ceiling(0.99*length_sum_snp_index)]
	snp_cutoff_up_0.01<-order_sum_snp_index[ceiling(0.01*length_sum_snp_index)]
	p_h_data_99<-c(p_h_data_99,snp_cutoff_up_0.99) 
    p_l_data_99<-c(p_l_data_99,snp_cutoff_up_0.01)  
	##########snp_index_probabirity_0.01######################      
}
    
        
FINAL_DATA<-data.frame(DEPTH=depth_data,P_L_95=p_l_data_95,P_H_95=p_h_data_95,P_L_99=p_l_data_99,P_H_99=p_h_data_99)
table_name<-paste("test.txt",sep="")
write.table(FINAL_DATA,table_name,sep="\t", quote=F, append=F,row.name=F)
    
 
    
    




