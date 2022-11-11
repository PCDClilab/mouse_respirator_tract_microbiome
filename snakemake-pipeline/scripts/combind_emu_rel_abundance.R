#! ~/miniconda3/envs/r4-base/bin/R
library(dplyr)
library(stringi)
library(ConfigParser)
library(argparse)

###################################################
# set the parameter
###################################################
parser=ArgumentParser()
parser$add_argument("--input_dir", help="emu result directory")

##define the args
args <- parser$parse_args()
str(args)
input_dir = as.character(args$input_dir)

combind = function(level){
files= list.files(input_dir,pattern = paste0("_rel-abundance-",level,".tsv"))
file = files[1]
file = paste(input_dir,file,sep="/")
sample = stri_match(file,regex = "01.Emu.collapse/(.+)_rel-abundance")[2]
result = read.csv(file,sep="\t")
result = data.frame(sample = sample, result)

for (file in files[2:length(files)]){
file = paste(input_dir,file,sep="/")
temp  = read.csv(file,sep="\t")
sample = stri_match(file,regex = "01.Emu.collapse/(.+)_rel-abundance")[2]
temp = data.frame(sample = sample, temp)
result = rbind(result,temp)
}
out_file = paste0("03.combindResult/combind_rel_abundance-",level,".csv")
write.csv(result,out_file,row.names=F,quote = F)

}
combind(level = "species")
combind(level = "genus")
combind(level = "family")
combind(level = "order")
combind(level = "class")
combind(level = "phylum")



