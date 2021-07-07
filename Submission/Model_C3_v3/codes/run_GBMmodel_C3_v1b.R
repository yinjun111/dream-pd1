

library(caret)
library(gbm)

#load testdata features

#Load model
#------
load("/codes/Model_GBM_C3_v3.rdata")

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

#New features
#-------------

#tmb cates
testdata.tmb.cate<-rep("M",length(testdata.tmb))
testdata.tmb.cate[testdata.tmb>quantile(testdata.tmb,0.66)]<-"H"
testdata.tmb.cate[testdata.tmb<quantile(testdata.tmb,0.33)]<-"L"

#PD-L1
testdata.pdl1.cate<-rep("H",ncol(testdata.exp))
testdata.pdl1.cate[testdata.exp.z["CD274",]<0]<-"L"

#PCA

data.exp.pca<-prcomp(t(data.exp))$x[,1:5]

featurePlot(data.exp.pca,y = as.factor(data.anno$ORR),plot = "pairs",)

#testing PCA
library(ggfortify)

training1.exp<-training1[,1:89]

testing1.exp<-testing1[,1:89]

training1.exp.pca<-prcomp(training1.exp)


testing1.exp.pca<-predict(training1.exp.pca,testing1.exp)


autoplot(training1.exp.pca,data = data.anno[data.anno$Study!="Hugo2016",], colour = 'ORR')

plot(testing1.exp.pca[,c(1,2)],col=data.anno[data.anno$Study=="Hugo2016","ORR"]+1)

points(training1.exp.pca$x[,c(1,2)],pch="*",col=data.anno[data.anno$Study!="Hugo2016","ORR"]+1)


#Percentage of ORR

data.orr.perc<-as.vector(unlist(lapply(split(data.anno$ORR,data.anno$Study),function(x){
  
  perc<-rep(sum(x==1)/length(x),length(x))
  perc
})))


data.newfeatures<-as.data.frame(cbind(data.tmb.cate,data.pdl1.cate,data.exp.pca,data.orr.perc))

colnames(data.newfeatures)<-c("TMBCate","PDL1Cate","PC1","PC2","PC3","PC4","PC5","ORRPerc")




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
