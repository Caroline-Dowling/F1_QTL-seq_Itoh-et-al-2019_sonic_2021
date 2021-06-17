##############################################################
Arg<-commandArgs(TRUE)
data_snp<-c(Arg[1])
line_number<-c(Arg[2])
defined_p_value<-c(Arg[3])
##############################################################
defined_p_value<-as.numeric(defined_p_value)
# m_Parent_A_vs_F1.pileup
# V1	V2	V3	V4	V5	V6			V7			V8	V9			V10			V11		V12	V13
# A01	6078	T	G	13	..,.,.,,,,,.,	EEE/EEEEEEEAE	16	..G,,.,.,,,.,,,.	JJ7JJJJJJJJJFJJF	0.0625	1	15
# A01	6084	A	T	14	..,.,.,,,,,.,^/,	AEEEEAEEEEEEE=	15	TT,tT,Tt,t.,ttT	JJJJJJJFJJJJJJJ	0.666666666666667	10	5
# A01	6278	A	T	8	,,,,..,,	EEEAEEEE	17	,,,..,...,.,.,T,.	AJJJ7JJJJJoJJJJJJ	0.0588235294117647	1	16
# A01	8367	A	G	17	,,,,,,,,..,,.,.,,	EEEEEEEEEEEEEEAEE	18	gGg,gGGGg,.Gg,..g,	0JJJJJJJJJJJJFJJJJ	0.611111111111111	11	7
# A01	8831	C	T	12	,,,,,.,..,,^>,	AEA/EEAEEEE=	16	,TTTtTt,TT,,,,..	FJssJJJJJJJJJJJF	0.5	8	8

f<-file(data_snp,"r")
segregation_ratio<-c(1,1)
segregation_ratio_p<-segregation_ratio/sum(segregation_ratio)
data_snp <-sub("\\S+/","", data_snp)
out_put<-paste("./Fishire_test_", data_snp,sep="")

on_off<-0
for(i in 1:line_number){
	a<-readLines(con=f,1)
	v<-as.vector(strsplit(a,"\t")[[1]])
	
	mt_allele_in_Parent_A<-0
	wt_allele_in_Parent_A<-as.numeric(v[5])
	
	mt_allele_in_F1<-as.numeric(v[12])
	wt_allele_in_F1<-as.numeric(v[13])
	
	table=matrix(c(mt_allele_in_Parent_A, mt_allele_in_F1, wt_allele_in_Parent_A, wt_allele_in_F1), nrow=2, byrow=T, dimnames=list(c("cat.A", "cat.B"), c("item.1","item.2")))

	if(mt_allele_in_Parent_A>=0 & wt_allele_in_Parent_A>=0 & mt_allele_in_F1>=0 & wt_allele_in_F1>=0){
		p_vlue_of_fishers_test<-fisher.test(table)$p.value
		
		if(p_vlue_of_fishers_test<defined_p_value){
			print_vector<-c(v ,p_vlue_of_fishers_test)		
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
