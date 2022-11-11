# -*- encoding: utf-8 -*-
'''
@Date     :  2022/09/23 
@Author   :  liumanjiao
@email    :  manjiao.liu@simceredx.com
@version  :  1.0
'''
import argparse
import csv
import pandas as pd
import numpy as np
import re,os

###  Config File ##########
configfile: "/gpfsdata/Project/06.influenza-mouse-16S/02.test/snakemake_test/00.snakemake/config.yaml"
workdir: os.getcwd()
outdir = os.getcwd()
sampleInfo_file=os.path.join(outdir,"")
sampleInfo_file="SampleInfo.txt"
sampleInfo  =  pd.read_csv(sampleInfo_file,dtype=str,sep="\t").set_index(["Sample"],drop=False)
samples = [i for i in sampleInfo.index]
bc_dict = sampleInfo['Data'].to_dict()
levels = ["species","genus","family","order","class","phylum"]
last_sample = samples[1]
####### run rules ############
#定义全部输出文件
rule all:
    input:
        expand ("00.merge_data/{sample}.fastq",sample = samples),
        expand ("01.Emu/{sample}_emu_alignments.sam",sample = samples),
        expand ("01.Emu/{sample}_read-assignment-distributions.tsv",sample = samples),
        expand ("01.Emu/{sample}_rel-abundance.tsv",sample = samples),
        expand ("01.Emu/{sample}_unclassified.fq",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance.tsv", sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-species.tsv",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-genus.tsv",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-family.tsv",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-order.tsv",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-class.tsv",sample = samples),
        expand ("01.Emu.collapse/{sample}_rel-abundance-phylum.tsv",sample = samples),
        expand ("02.mapping.stats/{sample}.map.stats",sample = samples),
        expand ("00.NanoQC/{sample}.QC", sample = samples),
        "03.combindResult/combind_rel_abundance-species.csv",
        "03.combindResult/combind_rel_abundance-genus.csv",
        "03.combindResult/combind_rel_abundance-family.csv",
        "03.combindResult/combind_rel_abundance-order.csv",
        "03.combindResult/combind_rel_abundance-class.csv",
        "03.combindResult/combind_rel_abundance-phylum.csv",
        "03.combindResult/combind_rel_abundance.csv",
        "03.combindResult/combind_mapping_stats.csv",
        expand ("04.data_matrix/combind_data_matrix-{level}.csv",level = levels),
        expand ("04.data_matrix/combind_data_matrix-reads-{level}.csv",level = levels),
        expand ("04.data_matrix/group_mean-{level}.csv", level = levels),
        "05.alpha_diversity/alhpa_diversity-species.csv",
        "05.alpha_diversity/alhpa_diversity-genus.csv",
        "05.beta_diversity/beta_diversity-species.csv",
        "05.beta_diversity/beta_diversity-genus.csv",

include: 'rules/00.1.NanoQC.rules'
include: 'rules/00.mergeData.rules'
include: 'rules/01.Emu.rules'
include: 'rules/01.1.Emu.collapse.rules'
include: 'rules/02.mappingStats.rules' 
include: 'rules/03.combind.results.rules'
include: 'rules/04.data_matrix.rules'
include: 'rules/05.data_matrix_reads.rules'
include: 'rules/06.group_mean.rules'
include: 'rules/07.alpha_diversity.rules'
include: 'rules/08.beta_diversity.rules'


