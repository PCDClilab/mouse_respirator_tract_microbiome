#! ~/miniconda3/envs/r4-base/bin/R
library(dplyr)
library(stringi)
library(ConfigParser)
library(argparse)
library(reshape2)

###################################################
# set the parameter
###################################################
parser=ArgumentParser()
parser$add_argument("--input", help="input abundance matrix")
parser$add_argument("--output", help="output file name")

##define the args
args <- parser$parse_args()
str(args)
input = as.character(args$input)
output= as.character(args$output)

data = read.csv(input,head=T,row.names=1)
data = t(data) %>% data.frame()
meta_data  = read.csv("SampleInfo.txt", sep = "\t")
meta_data$Sample = gsub("-",".",meta_data$Sample)
data$Group = meta_data$Group[match(row.names(data),meta_data$Sample)] %>% as.vector()
data$Sample = row.names(data)
data = melt(data)
data_mean = aggregate(data$value,by=list(tax=data$variable,Group=data$Group),
                      FUN=mean)
data_mean = dcast(data_mean,tax~Group) %>% head()

write.csv(data_mean,file = output,row.names=F)
