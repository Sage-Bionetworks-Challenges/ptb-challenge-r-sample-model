library(randomForest)
library(glmnet)
library(readr)
library(optparse)

#example using phyloptype rel. abundance

meta = as.data.frame(read_csv("./input/metadata/metadata.csv"))
rownames(meta)<-meta$specimen

phy = as.data.frame(read_csv("./input/phylotypes/phylotype_relabd.5e_1.csv"))
rownames(phy)=phy$specimen
phy$specimen<-NULL


mf=cbind(meta,phy[meta$specimen,])

#per challenge rules limit to collection by 28 weeks
mf=mf[mf$collect_wk<=32,]  #change this for SC2
#deal with multiple samples per patient by keeping the first one; better methods should be used 
mf=mf[!duplicated(mf$participant_id),]

mf$Y=factor(ifelse(mf$delivery_wk<37,1,0)) #change this for SC2


X=mf[,colnames(phy)]

model=randomForest(x=X,y=mf$Y,ntree=50,importance=FALSE)


#for checking only
probs = predict(model,X,type="prob")[,"1"]
pred.classes = ifelse(probs>0.5,1,0)

saveRDS(model, file="model.rds")
