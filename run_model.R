library(readr)
library(optparse)
library(randomForest)
library(glmnet)

option_list <- list(
  make_option("--input", type="character", default="/input",
              help="Input directory [default=/input]", metavar="character"),
  make_option("--output", type="character", default="/output", 
              help="Output directory [default=/output]", metavar="character")
) 

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

meta = as.data.frame(read_csv(file.path(opt$input, "/metadata/metadata.csv")))
rownames(meta)=meta$specimen


phy = as.data.frame(read_csv(file.path(opt$input, "/phylotypes/phylotype_relabd.5e_1.csv")))
rownames(phy)=phy$specimen
phy$specimen<-NULL



mf=cbind(meta,phy[meta$specimen,])

mf=mf[mf$collect_wk<=28,]
mf=mf[!duplicated(mf$participant_id),]


model = readRDS("/usr/local/bin/model.rds")
inpt=mf[,colnames(phy)]
#for checking only
probs = predict(model,inpt,type="prob")[,"1"]
pred.classes = ifelse(probs>0.5,1,0)
output_df = data.frame(
  participant = mf$participant_id,
  was_preterm = pred.classes,
  probability =  probs
) #change here for SC2 was_preterm==>was_early_preterm
write_csv(output_df,  file.path(opt$output, "predictions.csv"))
