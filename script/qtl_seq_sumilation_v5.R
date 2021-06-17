####################################
Arg<-commandArgs(TRUE)
###########input###############################################

individual_analysis<- c(Arg[1])
reprication<-c(Arg[2])
filter_value<-c(Arg[3])
population_structure<-c(Arg[4]) #RIL or F2
depth_analysis<-c(1:300)
###########input###############################################



###########genotype#############################
genotype<-function(){
	count<-0
	
	
	if (population_structure=="RIL"){
		x<-runif(1) 
		if (x<=0.5){
			count<-1
		}else{
			count<-0
		}	
		
	}else{
		for(i in 1:2){
			x<-runif(1) 
			if (x<=0.5){
				number<-0.5
			}else{
				number<-0
			}	
			if(number == 0.5){
				count<- count+0.5
			}
		}
	}
	return(count)
}
############################################################


###########caluclate of genotype ratio#########################

individuals_genotype<-function(number_of_total_individuals){
	
	ratio_of_genotype<-c()
	for(i in 1:number_of_total_individuals){
		ratio_of_genotype<-c(ratio_of_genotype,genotype())
		
	}
	return(mean(ratio_of_genotype))	
}
############################################################


###########SNP_index_caluclation#########################

snp_index<-function(read_depth,ratio_of_genotype_in_the_population_in_A){
	x1<-rbinom(1,read_depth,ratio_of_genotype_in_the_population_in_A)
	return(x1/read_depth)	
}
############################################################

####################################






for (key_individual in individual_analysis){
   individual_number<-key_individual
    
    depth_data<-c()
    p_l_data_95<-c()
    p_h_data_95<-c()
    p_l_data_99<-c()
    p_h_data_99<-c()
    for (key_depth in depth_analysis){
        depth_data<-c(depth_data,key_depth)
        depth<-key_depth
    
        data_of_delta_snp_index<-c()
        
        for(i in 1:reprication){    
        ##########gene_frequency######################
			ratio_of_genotype_in_the_population_in_A<-individuals_genotype(key_individual)
			Snp_index_of_A<-snp_index(key_depth,ratio_of_genotype_in_the_population_in_A)
			
			ratio_of_genotype_in_the_population_in_B<-individuals_genotype(key_individual)
			Snp_index_of_B<-snp_index(key_depth,ratio_of_genotype_in_the_population_in_B)			
			
			if(Snp_index_of_A >= filter_value | Snp_index_of_B >=filter_value){
				delta_snp_index<-Snp_index_of_A-Snp_index_of_B
				data_of_Snp_index_of_A <-c(data_of_Snp_index_of_A, Snp_index_of_A)
				data_of_Snp_index_of_B <-c(data_of_Snp_index_of_B, Snp_index_of_B)
				data_of_delta_snp_index<-c(data_of_delta_snp_index,delta_snp_index)
			}
						
		##########gene_frequency######################
        }
        
        order_data_of_Snp_index_of_A<-sort(data_of_Snp_index_of_A)
        length_data_of_Snp_index_of_A<-length(data_of_Snp_index_of_A)       

        order_data_of_Snp_index_of_B<-sort(data_of_Snp_index_of_B)
        length_data_of_Snp_index_of_B<-length(data_of_Snp_index_of_B)       
              
        order_data_of_delta_snp_index<-sort(data_of_delta_snp_index)
        length_data_of_delta_snp_index<-length(data_of_delta_snp_index)

        ##########snp_index_probabirity_0.05######################       
        snp_cutoff_low_0.025<-order_data_of_delta_snp_index[floor(0.025*length_data_of_delta_snp_index)]
		snp_cutoff_up_0.975<-order_data_of_delta_snp_index[ceiling(0.975*length_data_of_delta_snp_index)]

        snp_cutoff_low_sampleA_0.025<-order_data_of_Snp_index_of_A[floor(0.025*length_data_of_Snp_index_of_A)]
		snp_cutoff_up_sampleA_0.975<-order_data_of_Snp_index_of_A[ceiling(0.975*length_data_of_Snp_index_of_A)]
		
        snp_cutoff_low_sampleB_0.025<-order_data_of_Snp_index_of_B[floor(0.025*length_data_of_Snp_index_of_B)]
		snp_cutoff_up_sampleB_0.975<-order_data_of_Snp_index_of_B[ceiling(0.975*length_data_of_Snp_index_of_B)]	
		
		p_l_data_95<-c(p_l_data_95,snp_cutoff_low_0.025)
        p_h_data_95<-c(p_h_data_95,snp_cutoff_up_0.975)  
        
		p_l_data_95_sampleA<-c(p_l_data_95_sampleA, snp_cutoff_low_sampleA_0.025)
        p_h_data_95_sampleA<-c(p_h_data_95_sampleA, snp_cutoff_up_sampleA_0.975)          
        
		p_l_data_95_sampleB<-c(p_l_data_95_sampleB, snp_cutoff_low_sampleB_0.025)
        p_h_data_95_sampleB<-c(p_h_data_95_sampleB, snp_cutoff_up_sampleB_0.975)               
         
        #-------------------------------------------------------------------------
        
        ##########snp_index_probabirity_0.01###################### 
        if (floor(0.005*length_data_of_delta_snp_index)>0){
        	snp_cutoff_low_0.005<-order_data_of_delta_snp_index[floor(0.005*length_data_of_delta_snp_index)]
        	snp_cutoff_low_sampleA_0.005<-order_data_of_Snp_index_of_A[floor(0.005*length_data_of_Snp_index_of_A)]
        	snp_cutoff_low_sampleB_0.005<-order_data_of_Snp_index_of_B[floor(0.005*length_data_of_Snp_index_of_B)]
        	
        }else{
        	snp_cutoff_low_0.005<-order_data_of_delta_snp_index[1]
        	snp_cutoff_low_sampleA_0.005<-order_data_of_Snp_index_of_A[1]
        	snp_cutoff_low_sampleB_0.005<-order_data_of_Snp_index_of_B[1]        	     	
        }      
        
        if (ceiling(0.995*length_data_of_delta_snp_index)<length_data_of_delta_snp_index){
			snp_cutoff_up_0.995<-order_data_of_delta_snp_index[ceiling(0.995*length_data_of_delta_snp_index)]
			snp_cutoff_up_sampleA_0.995<-order_data_of_Snp_index_of_A[ceiling(0.995*length_data_of_Snp_index_of_A)]			
			snp_cutoff_up_sampleB_0.995<-order_data_of_Snp_index_of_B[ceiling(0.995*length_data_of_Snp_index_of_B)]			
		}else{
			snp_cutoff_up_0.995<-order_data_of_delta_snp_index[length_data_of_delta_snp_index]
			snp_cutoff_up_sampleA_0.995<-order_data_of_Snp_index_of_A[1]			
			snp_cutoff_up_sampleB_0.995<-order_data_of_Snp_index_of_B[1]			
		}
		p_l_data_99<-c(p_l_data_99,snp_cutoff_low_0.005)
        p_h_data_99<-c(p_h_data_99,snp_cutoff_up_0.995)

		p_l_data_99_sampleA<-c(p_l_data_99_sampleA, snp_cutoff_low_sampleA_0.005)
        p_h_data_99_sampleA<-c(p_h_data_99_sampleA, snp_cutoff_up_sampleA_0.995)          
        
		p_l_data_99_sampleB<-c(p_l_data_99_sampleB, snp_cutoff_low_sampleB_0.005)
        p_h_data_99_sampleB<-c(p_h_data_99_sampleB, snp_cutoff_up_sampleB_0.995)              
        
         
        ##########snp_index_probabirity_0.01######################      
               
            
     
     
    }
            
    FINAL_DATA<-data.frame(
	    DEPTH=depth_data,
	    P_L_95=p_l_data_95,
	    P_H_95=p_h_data_95,
	    P_L_99=p_l_data_99,
	    P_H_99=p_h_data_99,
	    P_L_95_A=p_l_data_95_sampleA,
	    P_H_95_A=p_h_data_95_sampleA,
	    P_L_99_A=p_l_data_99_sampleA,
	    P_H_99_A=p_h_data_99_sampleA,    
	    P_L_95_B=p_l_data_95_sampleB,
	    P_H_95_B=p_h_data_95_sampleB,
	    P_L_99_B=p_l_data_99_sampleB,
	    P_H_99_B=p_h_data_99_sampleB    
    )
    
    
    
    table_name<-paste("./",population_structure,"_",individual_number,"_individuals.txt",sep="")
    
    write.table(FINAL_DATA,table_name,sep="\t", quote=F, append=F,row.name=F)
    
}  
    
    
    
    




