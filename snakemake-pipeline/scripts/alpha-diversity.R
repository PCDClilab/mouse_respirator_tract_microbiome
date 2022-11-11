#! ~/miniconda3/envs/r4-base/bin/R
library(vegan)
library(ConfigParser)
library(argparse)
###################################################
# set the parameter
###################################################
parser=ArgumentParser()
parser$add_argument("--input", help="input abundance matrix")
parser$add_argument("--output", help="output alpha diversity file name")

##define the args
args <- parser$parse_args()
str(args)
input = as.character(args$input)
output= as.character(args$output)

data = read.csv(file = input,row.names=1)
otu = t(data)
Chao1  <- estimateR(otu)[2, ]
Shannon <- diversity(otu, index = 'shannon', base = exp(1))
result = rbind(Chao1,Shannon)
result = data.frame(index=row.names(result),result)
write.csv(result,output,row.names=F)



