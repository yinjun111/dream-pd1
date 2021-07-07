

setwd("C:\\Projects_External\\DREAM\\Submission\\Model_C3_v3\\test")

library(caret)
library(gbm)
library(pROC)

test<-read.csv("../../../SyntheticData/Test/GRCh37ERCC_refseq105_genes_tpm.csv",header=T,row.names=1)


anno<-read.table("../../../SyntheticData/Test/Clougesy2019_clinical_data_rev.txt",header=T,row.names=1,sep="\t")


head(anno)

anno.sel<-anno[anno[,1]!="Patient_15_tumor",]


prediction<-read.csv("../../../SyntheticData/Test/predictions.csv",row.names = 1,header=T)



plot(roc(make.names(anno[rownames(prediction),1]),prediction[,1]), print.auc = TRUE,col="red",print.auc.y=.1)

