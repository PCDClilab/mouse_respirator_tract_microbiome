# mouse_respirator_tract_microbiome
This is a snakemake workflow written in Python for analyzing full-length 16S sequences from nanopore sequencing using the EMU [1] software. The workflow includes steps inclunding NanoQC, merging fastq data from the same sample, EMU analysis to obtain a species abundance matrix, and using the abundance matrix for alpha and beta diversity analysis. Using this workflow only requires two steps:
1. Prepare a sample info file, following the format of SampleInfo.txt.
2. Run the run_emu.py file using snakemake.

[1] Curry KD, Wang Q, Nute MG, et al. Emu: species-level microbial community profiling of full-length 16S rRNA Oxford Nanopore sequencing data. Nat Methods. 2022;19(7):845-853. doi:10.1038/s41592-022-01520-4
