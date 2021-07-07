
library(binfotron)
library(data.table)

args<- commandArgs(trailingOnly=TRUE)

#setwd("C:\\Projects_External\\DREAM\\FeatureGen\\IMPRES")
#tpm<-read.csv("gene.results.merged.tpm.renamed.txt",row.names = 1,as.is = T)

tpm<-read.csv(args[1],row.names = 1,as.is = T)

#genes required by IMPRES
genes.sel<-c("PDCD1","CD27", "CTLA4","CD40", "CD86", "CD28", "CD80","CD274","TNFRSF14","TNFSF4","TNFSF9","VSIR","HAVCR2","CD200","CD276")

#create data table
tpm.sel<-tpm[rownames(tpm) %in% genes.sel,]

ge<-rbind(colnames(tpm.sel),colnames(tpm.sel),tpm.sel)
rownames(ge)<-c("Run_ID","sample_key",rownames(tpm.sel))

ge.df<-setDT(as.data.frame(t(ge)))

#Run IMPRES
ge.result<-calc_impres(ge.df)

#write results
write.csv(file=args[2],ge.result,row.names = F,quote = F)
