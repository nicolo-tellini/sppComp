# Title: PLOT
# Author: Nicolò T.
# Status: Complete
# Input: /cov/binned.cov files
# Output: A single pdf with all sample plots (in ./plots)

# Comment: 
# 1) required libraries: ggplot2 (3.4.0), tidyverse (1.3.2) and data.table (1.14.6).
# 2) library versions correspond to those used during the development of the pipeline

# Options ---

rm(list = ls())
options(warn = 1)
options(stringsAsFactors = F)

# SETTINGS ----

 argsVal <- commandArgs(trailingOnly = T)
 baseDir <- argsVal[1]
 binsize <- as.numeric(argsVal[2])
 
 setwd(baseDir)

# Libraries ----

library(ggplot2)
library(data.table)
library(tidyverse)

# Variables ----

refs <- c("Scer","Spar","Smik","Sjur","Skud","Sarb","Seub","Suva")

# note: rearranged chromosomes are assigned based on CEN.
# ex.: chrI of S.jur contain a long piece of chrXIII, nevertheless we refer to the former as chrI! 
allChr <- c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI","chrVII", "chrVIII","chrIX","chrX","chrXI", "chrXII","chrXIII", "chrXIV", "chrXV", "chrXVI")

# Functions ----

# Add additional columns
add_columns <- function(x){ 
  x$species <- sapply(strsplit(x[,1],"_"),"[[",2)
  x$species <- factor(x$species,levels = refs)
  x$chr <- sapply(strsplit(x[,1],"_"),"[[",1)
  x$chr <- factor(x$chr,levels=allChr)
  x <- x[order(x[,1],x[,2]),]
  x$diff <- (x[,3] + x[,2])/2
  x$rname <- factor(x$rname,levels=unique(x$rname))
  df_temp <- split(x,x$rname)
  add_rankcol <- function(z) {
    z$rank_chr <- 1:nrow(z)
    return(z)
  }
  df_temp <- lapply(df_temp,add_rankcol)
  df_temp <- do.call(rbind, df_temp)
  return(df_temp)
}

# plot the coverage across consecutive windows across chromosomes and species
# color gradient reflects per-window average mapping quality
plot_fun <- function(x) {
  ymax <- median(x[x$meandepth>0,"meandepth"])*4
  plot_list <- ggplot(x,mapping = aes(x=rank_chr,y=meandepth,color=meanmapq)) + 
    geom_line() +
    scale_color_gradient(low = "orange", high = "darkgreen", na.value = NA) +
    facet_grid(rows=vars(species),cols=vars(chr),scales = "free_x") +
    coord_cartesian(ylim = c(0, ymax))+
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      text = element_text(size = 12,colour = "black"),
      axis.text.y = element_text(size = 12,colour = "black")
    ) +
    ylab(paste0("Average coverage\n(",binsize/1000,"kb non overlapping windows)")) +
    ggtitle(paste0("sample: ",unique(x$strain)))
  return(plot_list)
}

# body ----

# list coverage files
cov_files <- list.files(path = paste0(baseDir,"/cov/"),pattern = ".cov$")

# create output directory
outDir <- paste0(baseDir,"/plots")

dir.create(outDir,showWarnings = F,recursive = T)

# load all coverage files
df <- lapply(cov_files,function(x) fread(cmd = paste0("cut -f1,2,3,7,9,10 ",baseDir,"/cov/",x),data.table = FALSE))

# rename list elements
strains <- sapply(strsplit(cov_files,"\\."),"[[",1)
names(df) <- strains

# rename columns of each data.frame
cols <- c("rname","startpos","endpos","meandepth","meanmapq","strain")
df <- lapply(df,setNames,cols)

# remove info of mitoDNA
df <- lapply(df, function(x) x[grep("chrMT",x[,1],value = F,invert = T),])

# reshape the columns for the plots
df <- lapply(df,add_columns)

# ggplot2 and save the output to a single pdf
plotPath <- file.path(paste0(outDir,"/all_strains.speciescomponent.pdf"))
pdf(file = plotPath, width = 12, height = 8)
lapply(df, plot_fun)
dev.off()
