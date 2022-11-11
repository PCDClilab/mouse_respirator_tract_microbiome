#! ~/miniconda3/envs/r4-base/bin/R
library(dplyr)
library(stringi)
library(ConfigParser)
library(argparse)

###################################################
# set the parameter
###################################################
parser=ArgumentParser()
parser$add_argument("--input", help="emu result directory")
parser$add_argument("--out", help="output file name")


##define the args
args <- parser$parse_args()
str(args)
input = as.character(args$input)
out = as.character(args$out)
sample = stri_match(input,regex = "01.Emu.collapse/(.+)_rel-abundance-filterRO.tsv")[2]
temp  = read.table(input,sep="\t",head = T)
temp$estimated.counts = as.numeric(temp$estimated.counts)
temp$abundance = as.numeric(temp$abundance)
sum = sum(temp$estimated.counts[temp$tax_id != "unassigned"])
temp$abundance = temp$estimated.counts/sum
temp$abundance[temp$tax_id == "unassigned"] = 0
write.table(temp,out,row.names=F,quote = F,sep ="\t")



