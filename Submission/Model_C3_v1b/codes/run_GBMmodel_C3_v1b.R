

library(caret)
library(gbm)

#load testdata features

#Load model
#------
load("/codes/Model_GBM_C3_v1b.rdata")

#setwd("C:\\Projects_External\\DREAM\\Model\\SyntheticDataFeatures")
#load("Model_GBM_v1.rdata")




#expr
#-------
testdata.exp<-read.csv("/output/testdata_filtered.txt",header=T,row.names=1)
testdata.exp<-testdata.exp[rownames(data.exp),]

#Anno
#------
testdata.anno<-read.csv("/data/clinical_data.csv",header=T,row.names=1)

testdata.anno<-testdata.anno[colnames(testdata.exp),] #make sure these two data are the same

testdata.anno.sex<-rep(0,nrow(testdata.anno))
testdata.anno.sex[testdata.anno$SEX=="M"]=1
testdata.anno.sex<-factor(make.names(testdata.anno.sex))
  
testdata.anno.age<-as.integer(testdata.anno$AAGE/10)

#Z score
#----------

#convert to z
testdata.exp <-t(apply(testdata.exp,1,function(x){
    if(sd(x)==0 || is.na(sd(x)) ) {
      rep(0,length(x))
    } else {
      (x-mean(x))/sd(x)
    }
}))

colnames(testdata.exp)<-rownames(testdata.anno)

#fardeep
#-------
testdata.fardeep<-read.csv("/output/testdata_fardeep.txt",header=T,row.names = 1) #
testdata.fardeep[is.na(testdata.fardeep)]<-0

testdata.fardeep<-testdata.fardeep[,colnames(data.morefeatures)[1:11]]

#GEP
#----------
testdata.gep<-read.csv("/output/testdata_gep.txt",header=T,row.names = 1)
testdata.gep[is.na(testdata.gep)]<-0


#IMPRES
#----------
testdata.impres<-read.csv("/output/testdata_impres.txt",header=T,row.names = 1)
testdata.impres[is.na(testdata.impres)]<-0

#MIXCR
#----------
testdata.mixcr<-testdata.anno[,c(9,10,8,12,13,11)]
testdata.mixcr[is.na(testdata.mixcr)]<-0

#ssGSEA
#--------
testdata.gsea<-read.csv("/output/testdata_ssgsea_all_selected.txt",header=T,row.names = 1) #
testdata.gsea[is.na(testdata.gsea)]<-0


#SZABO
#---------
testdata.szabo<-read.csv("/output/testdata_szabo.txt",header=T,row.names = 1)
testdata.szabo[is.na(testdata.szabo)]<-0

#TIDE
#---------
testdata.tide<-read.csv("/output/testdata_tide.txt",header=T,row.names = 1)
testdata.tide[is.na(testdata.tide)]<-0


#TMB,kNN imputed
#---------
testdata.tmb<-read.csv("/output/testdata_tmb.txt",header=T,row.names = 1)


#All features
#-------------
testdata.morefeatures<-cbind(testdata.fardeep,testdata.gep,testdata.impres,testdata.szabo,testdata.tide,testdata.tmb,testdata.mixcr)


#Data used for testing
#-------------
testdata.merged<-cbind(t(testdata.exp),testdata.morefeatures,t(testdata.gsea),testdata.anno.sex,testdata.anno.age)


colnames(testdata.merged)<-colnames(data.merged)[-ncol(data.merged)]


#use trained GBM model on testdata
testdata.model.pred.prob<-predict(gbmFit.all,newdata=testdata.merged,type = "prob")

#final results
results  <- data.frame("patientID" = colnames(testdata.exp) ,"prediction"=testdata.model.pred.prob[,2])

# write out prediciton file
write.csv(results, file = "/output/predictions.csv", quote = F, row.names = F)
#write.csv(results, file = "predictions.csv", quote = F, row.names = F)
