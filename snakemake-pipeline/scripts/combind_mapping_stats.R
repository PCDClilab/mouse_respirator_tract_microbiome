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
parser$add_argument("--out_file", help="output file name")


##define the args
args <- parser$parse_args()
str(args)
input_dir = as.character(args$input_dir)
out_file = as.character(args$out_file)
files= list.files(input_dir,pattern = ".map.stats$")
file = files[1]
file = paste(input_dir,file,sep="/")
sample = stri_match(file,regex = "02.mapping.stats/(.+).map.stats$")[2]

f = file(file,open = "r")
lines = readLines(f)
total_reads =  lines[1] %>% as.numeric()
mapped_reads = lines[2] %>% as.numeric()
mapped_ratio = mapped_reads/total_reads
mapped_ratio = sprintf("%1.2f%%", 100*mapped_ratio)

file_unassigned = paste0("01.Emu/",sample,"_unclassified.fq")
unassigned_reads = system(paste0("wc -l ",file_unassigned),intern = T)   ##统计unassigned_reads的数目
unassigned_reads = unlist(strsplit(unassigned_reads,split=" "))[1]  %>% as.numeric()
unassigned_reads = unassigned_reads/4
unassigned_ratio = unassigned_reads/as.numeric(total_reads)
unassigned_ratio = sprintf("%1.2f%%", 100*unassigned_ratio)

result = data.frame(sample = sample, total_reads = total_reads, mapped_reads = mapped_reads, mapped_ratio = mapped_ratio,
                    unassigned_reads = unassigned_reads, unassigned_ratio = unassigned_ratio)



for (file in files[2:length(files)]){
file = paste(input_dir,file,sep="/")
sample = stri_match(file,regex = "02.mapping.stats/(.+).map.stats$")[2]
f = file(file,open = "r")
lines = readLines(f)
total_reads =  lines[1] %>% as.numeric()
mapped_reads = lines[2] %>% as.numeric()
mapped_ratio = mapped_reads/total_reads
mapped_ratio = sprintf("%1.2f%%", 100*mapped_ratio)

file_unassigned = paste0("01.Emu/",sample,"_unclassified.fq")
unassigned_reads = system(paste0("wc -l ",file_unassigned),intern = T)   ##统计unassigned_reads的数目
unassigned_reads = unlist(strsplit(unassigned_reads,split=" "))[1]  %>% as.numeric()
unassigned_reads = unassigned_reads/4
unassigned_ratio = unassigned_reads/as.numeric(total_reads)
unassigned_ratio = sprintf("%1.2f%%", 100*unassigned_ratio)

temp = data.frame(sample = sample, total_reads = total_reads, mapped_reads = mapped_reads, mapped_ratio = mapped_ratio,
                    unassigned_reads = unassigned_reads, unassigned_ratio = unassigned_ratio)
result = rbind(result,temp)
}
write.csv(result,out_file,row.names=F,quote = F)



