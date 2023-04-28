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
parser$add_argument("--level", help="tax level")
parser$add_argument("--input", help="input file name")
parser$add_argument("--output", help="output file name")

##define the args
args <- parser$parse_args()
str(args)
level = as.character(args$level)
input = as.character(args$input)
output = as.character(args$output)

data = read.csv(input,head=T)
data = data[data[,level]!="",]
data_level = data[,c("sample",level,"estimated.counts")]
data_level$estimated.counts = round(data_level$estimated.counts,0)
data_level = na.omit(data_level)
data_level$sample = gsub("-",".",data_level$sample)
tax = unique(data_level[,level])
samples = unique(data_level$sample)
data_matrix = matrix(0,nrow=length(tax),ncol=length(samples))
row.names(data_matrix)=tax
colnames(data_matrix)=samples
data_matrix = data.frame(data_matrix)
for (i in 1:nrow(data_level)){
    sample = data_level$sample[i]
    tax = data_level[,level][i]
    data_matrix[tax,sample]=data_level$estimated.counts[i]
}
write.csv(data_matrix,file = output, row.names=T)

