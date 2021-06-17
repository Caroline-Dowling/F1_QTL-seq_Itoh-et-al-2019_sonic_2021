##############################################################
Arg<-commandArgs(TRUE)
data_snp<- c(Arg[1])
data_sliding<- c(Arg[2])
##############################################################
SNP_INDEX<-read.table(data_snp,header=F, as.is=TRUE, quote="", comment.char="", sep="\t")
WINDOW_AVE<-read.table(data_sliding,header=F, quote="", comment.char="", sep="\t")


chr<-unique(WINDOW_AVE$V1)
max_x_axis<-max(SNP_INDEX$V2/1000000)
number_colom_for_graph<-ceiling(length(chr)/5)
out_put_A=paste("./graph_bulkA_",data_sliding,".png",sep="")
png(file=out_put_A,width=1600,height=2000)
par(mfcol=c(5, number_colom_for_graph))
par(ps=30,lwd=4,bty="l",tck = -0.02)
par(xaxs="i", yaxs="i");
par(mar = c(6, 7.0,4, 10));



#A01	350000	0.479601226993865	0.462924335378323	0.0166768916155419
#A01	400000	0.480378640776699	0.462766990291262	0.0176116504854369
#A01	450000	0.495695652173913	0.4676	0.028095652173913



#A01	2788	105	112	42	15	0.46	101	125	45	16	0.5
#A01	7961	55	55	42	16	0.37	0	0	0	0	0
#A01	8367	28	79	56	11	0.72	0	0	0	0	0

for (chr_number in chr){
	
		key_a<-WINDOW_AVE[WINDOW_AVE$V1==chr_number,]
		key_b<-SNP_INDEX[SNP_INDEX$V1==chr_number,]		
		plot (key_b$V2/1000000,key_b$V5,main=print(chr_number),xlim=c(0, max_x_axis),ylim=c(0,1),xaxt="n",yaxt="n",type="p", pch=20,ps=5,col="darkgreen",xlab="",ylab="")
		abline(h=0, lty=3,lwd=3)


		par(new=T)		
		plot (key_a$V2/1000000,key_a$V10,type="l",lwd=7,col="gray63",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)
		par(new=T)		
		plot (key_a$V2/1000000,key_a$V11,type="l",lwd=7,col="gray63",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)




		#par(new=T)		
		#plot (key_a$V2/1000000,key_a$V12,type="l",lwd=7,col="darkgoldenrod2",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)
		#par(new=T)		
		#plot (key_a$V2/1000000,key_a$V13,type="l",lwd=7,col="darkgoldenrod2",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)

		
		par(new=T)
		plot (key_a$V2/1000000,key_a$V3,type="l",lwd=7,col="red",xlim=c(0, max_x_axis),ylim=c(0,1), cex.axis = 1,cex.lab=1,xlab="chr position (Mb)",ylab="SNP index",mgp=c(4,1.5,0),xaxt="n",yaxt="n",)
		axis(2, lwd=4,mgp=c(6,1.5,0),yaxp=c(-1,1,4))
     	axis(1, lwd=4,mgp=c(6,1.5,0))		

}
warnings()
dev.off()

