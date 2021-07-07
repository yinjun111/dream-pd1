
library(caret)

data.clinical<-read.table("training/data_clinical.txt",header=T,sep="\t")

data.szabo<-read.csv("training/data_szabo.txt",row.names = 1)
data.tide<-read.csv("training/data_tide.txt",row.names = 1)
data.impres<-read.csv("training/data_impres.txt",row.names = 1)

data.szabo.ordered<-data.szabo[data.clinical[,1],]
data.tide.ordered<-data.tide[data.clinical[,1],]
data.impres.ordered<-data.impres[data.clinical[,1],]


#pred.szabo<-prediction(data.szabo.ordered,data.clinical[,3])


boxplot(split(data.szabo.ordered,data.clinical[,3]))
boxplot(split(data.tide.ordered,data.clinical[,3]))
boxplot(split(data.impres.ordered,data.clinical[,3]))


znorm<-function(x) {
  (x-mean(x))/sd(x)
}

data.combined<-data.frame("Szabo"=data.szabo.ordered,"TIDE"=data.tide.ordered,"IMPRES"=znorm(data.impres.ordered),"ORR"=as.factor(data.clinical[,3]))


#--------------------
#logistic model with LOO
#--------------------

library(caret)

# define training control
train_control <- trainControl(method="LOOCV")
# train the model
model <- train(ORR~., data=data.combined, trControl=train_control, method="glm",family="binomial")
# summarize results
print(model)


#------------------
#Test data
#-----------------

test.szabo<-read.csv("output/test_szabo.txt",row.names = 1)
test.tide<-read.csv("output/test_tide.txt",row.names = 1)
test.impres<-read.csv("output/test_impres.txt",row.names = 1)

test.szabo.ordered<-test.szabo[rownames(test.szabo),]
test.tide.ordered<-test.tide[rownames(test.szabo),]
test.impres.ordered<-test.impres[rownames(test.szabo),]

test.combined<-data.frame("Szabo"=test.szabo.ordered,"TIDE"=test.tide.ordered,"IMPRES"=znorm(test.impres.ordered))

#--------------------
#Predict
#--------------------


model.pred<-predict(model,newdata=test.combined)
model.pred.prob<-predict(model,newdata=test.combined,type = "prob")

model_sig  <- data.frame("patientID" = rownames(test.szabo) ,"prediction"=model.pred.prob[,2])

write.csv(model_sig,file="output/predictions.csv", quote = F, row.names = F)

#default is "raw"
#confusionMatrix(model.pred,data.combined$ORR)

#or  "prob
#plot(roc(data.clinical[,3], data.szabo.ordered), print.auc = TRUE,col="blue",print.auc.y=.4)
#plot(roc(data.clinical[,3], data.tide.ordered), print.auc = TRUE,add=T,col="green",print.auc.y=.3)
#plot(roc(data.clinical[,3], data.impres.ordered), print.auc = TRUE,add=T,col="red",print.auc.y=.2)
#plot(roc(data.clinical[,3], model.pred.prob[,2]), print.auc = TRUE,add=T,col="black",print.auc.y=.1)
#legend("bottomright",fill=c("blue","green","red","black"),legend = c("Szabo","TIDE","IMPRES","LR"))
