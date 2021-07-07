
setwd("")

library('survival')
library('gbm')
# set random state
set.seed(0)

data(veteran, package = "randomForestSRC")
cat("Number of samples:", nrow(veteran), "\n")
cat("Columns of dataset:", colnames(veteran), "\n")
veteran[c(1:5), ]

# Sample the data and create a training subset.
train <- sample(1:nrow(veteran), round(nrow(veteran) * 0.80))
data_train <- veteran[train, ]
data_test <- veteran[-train, ]


model <- gbm(Surv(time, status) ~ .,
             distribution='coxph',
             data=data_train,
             n.trees=3000,
             shrinkage=0.005,
             interaction.depth=2,
             n.minobsinnode=5,
             cv.folds=4)
# values of loss function on training set for each tree
print(model$train.error[2901:3000])

best.iter <- gbm.perf(model, plot.it = TRUE, method = 'cv')

pred.train <- predict(model, data_train, n.trees = best.iter)
pred.test <- predict(model, data_test, n.trees = best.iter)

Hmisc::rcorr.cens(-pred.train, Surv(data_train$time, data_train$status))
