# Title: FASTA binner
# Author: Nicolò T.
# Status: Complete
# Input: /rep/saccharomyces_all_assemblies.fa
# Output: A BED file with bins in ./rep dir

# Comment: 
# 1) you can change the bins size changing binsize variable in USER SETTINGS section.
# 2) required libraries: Biostrings (2.66.0), GenomicRanges (1.50.2) and data.table (1.14.6).
# 3) library versions correspond to those used during the development of the pipeline

# Options ---

rm(list = ls())
options(warn = 1)
options(stringsAsFactors = F)

library(rstudioapi) 

# USER SETTINGS ----

 argsVal <- commandArgs(trailingOnly = T)
 BaseDir <- argsVal[1]
 binsize <- as.numeric(argsVal[2])
 
 setwd(BaseDir)

# Libraries ----

library(Biostrings)
library(GenomicRanges)
library(data.table)

# body ----

# read FASTA genome
mygenome <- readDNAStringSet(paste0(BaseDir,"/rep/saccharomyces_all_assemblies.fa"))

# get chr sizes
chrSizes <- width(mygenome)

# name chrSizes
names(chrSizes) <- names(mygenome)

# generate the bins
bins <- tileGenome(chrSizes, tilewidth=binsize, cut.last.tile.in.chrom=T)

setDT(bins)

# set column names
setnames(bins, c("chrom", "start", "end"))

# remove rows with NA
bins <- bins[!is.na(start)]

# remove strand and width columns
bins[, c("strand", "width") := NULL]

# save the table as BED file in ./rep 
fwrite(x = bins,file =paste0(BaseDir,"/rep/binnedGenome.",binsize,".bed"),append = F,quote = F,sep = "\t",row.names = F,col.names = F)
