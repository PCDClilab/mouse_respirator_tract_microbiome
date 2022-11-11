library("vegan")
library(GUniFrac)   
library(ape)   
library(dplyr)

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
######Bray-Curtis_distance
otu.bc<-vegdist(otu,method="bray")  
otu.bc=as.matrix(otu.bc)
write.csv(otu.bc,output,quote=F,row.names=T)  

