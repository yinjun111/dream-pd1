
#prerequisites
#needs if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
#BiocManager::install("preprocessCore")
# install.packages("FARDEEP")


library(FARDEEP)
data(LM22)

args<- commandArgs(trailingOnly=TRUE)

#####
#FARDEEP
######

#read in data
data<-read.csv(args[1],row.names = 1)

#compute
data.result = fardeep(LM22, data)

#write absolute score
#no quote for results
write.csv(file=args[2],data.result$abs.beta,col.names=NA,quote=F)


####
#GEP
####

#genes by original GEP
genes<-c("CD27","CD274","CCL5","CD276","CD8A","CMKLR1","CSCL9","CXCR6","HLA-DQA1","HLADRB1","HLA-E","IDO1","LAG3","NKG7","PDCD1LG2","PSMB10","STAT1","TIGIT")

#genes used for selected exprs
genes_sel<-c("CD27","CD274","CCL5","CD276","CD8A","CMKLR1","CXCR6","HLA-DQA1","HLA-E","IDO1","LAG3","NKG7","PDCD1LG2","PSMB10","STAT1","TIGIT")

#
cal_gep<-function(x) {
  gep.exprs<-x[rownames(data) %in% genes_sel]
  gep<-sum(log10(gep.exprs+0.01))
  gep
}

data.gep<-apply(data,2,cal_gep)
data.gep<-cbind(colnames(data),data.gep)
colnames(data.gep)<-c("Sample","GEP")

write.csv(file=args[3],data.gep,row.names=F,quote=F)
