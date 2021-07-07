
#use kNN to impute TMB

library(caret)

args <- commandArgs(trailingOnly=TRUE)

#data.expr<-read.csv("../FeatureGen/TMB-Syn/GRCh37ERCC_refseq105_genes_tpm.csv",header=T,row.names = 1)
#data.anno<-read.csv("../FeatureGen/TMB-Syn/clinical_data.csv",header=T,row.names = 1)

data.expr<-read.csv(args[1],header=T,row.names = 1)
data.anno<-read.csv(args[2],header=T,row.names = 1)

data.anno<-data.anno[colnames(data.expr),] #make sure these two data are the same

output<-args[3]


#filter data.expr
data.expr.sd<-apply(data.expr,1,sd)
data.expr.sel<-data.expr[order(data.expr.sd,decreasing = T)[1:2000],]


data.merged.tmb<-as.data.frame(cbind(t(data.expr.sel),data.anno$TMB))
colnames(data.merged.tmb)<-c(rownames(data.expr.sel),"TMB")

set.seed(300)

training <- data.merged.tmb[!is.na(data.merged.tmb$TMB),]
testing <- data.merged.tmb[is.na(data.merged.tmb$TMB),]


trainX <- training[,names(training) != "TMB"]
preProcValues <- preProcess(x = trainX,method = c("center", "scale"))

#10 times CV
ctrl <- trainControl(method="cv", number = 10) #,classProbs=TRUE,summaryFunction = twoClassSummary)

#fit KNN
knnFit <- train(TMB~ ., data = training, method = "knn", trControl = ctrl, preProcess = c("center","scale"), tuneLength = 20)


prediction<-as.integer(predict(knnFit,newdata = testing))

data.merged.tmb[is.na(data.merged.tmb$TMB),]<-prediction

tmb.results<-cbind(rownames(data.merged.tmb),data.merged.tmb$TMB)

colnames(tmb.results)<-c("Patient","TMB")


#write results
write.csv(file=output,tmb.results,quote = F, row.names = F)

