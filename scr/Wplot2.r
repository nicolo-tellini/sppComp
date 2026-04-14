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
baseDir = argsVal[1]
binsize <- as.numeric(argsVal[2])
# baseDir <- "/home/tello/sppComb"
# binsize <- 10000

setwd(baseDir)

# Libraries ----

library(ggplot2)
library(data.table)
library(tidyverse)
library(DNAcopy)

# Variables ----

refs <- c("Scer","Spar","Smik","Sjur","Skud","Sarb","Seub","Suva")

# note: rearranged chromosomes are assigned based on CEN.
# ex.: chrI of S.jur contain a long piece of chrXIII, nevertheless we refer to the former as chrI! 
allChr <- c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI","chrVII", "chrVIII","chrIX","chrX","chrXI", "chrXII","chrXIII", "chrXIV", "chrXV", "chrXVI")

# Functions ----

# Source - https://stackoverflow.com/a/8189441
# Posted by Ken Williams, modified by community. See post 'Timeline' for change history
# Retrieved 2026-04-12, License - CC BY-SA 4.0

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


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
plot_fun_MQ <- function(x) {
  ymax <- median(x[x$meandepth>5,"meandepth"])*2.5
  mod_val <- Mode(x[x$meandepth > 5,"meandepth"])
  plot_list <- ggplot(x,mapping = aes(x=rank_chr,y=meandepth,color=meanmapq)) + 
    geom_hline(yintercept = mod_val) +
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

plot_fun_BC <- function(x) {
  ymax <- median(x[x$meandepth>5,"meandepth"])*2.5
  mod_val <- Mode(x[x$meandepth > 5,"meandepth"])
  plot_list <- ggplot(x,mapping = aes(x=rank_chr,y=meandepth,color=perc_pos_covered)) + 
    geom_hline(yintercept = mod_val) +
    geom_line() +
    scale_color_gradient(low = "grey88", high = "darkblue", na.value = NA) +
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
outDir <- paste0(baseDir,"/out")

dir.create(outDir,showWarnings = F,recursive = T)

# load all coverage files
df <- lapply(cov_files,function(x) fread(cmd = paste0("cut -f1,2,3,6,7,9,10 ",baseDir,"/cov/",x),data.table = FALSE))

orderchr <- paste(allChr,rep(refs, each = length(allChr)), sep = "_")

df <- lapply(df,function(x) x %>% arrange(factor(V1, levels = orderchr),V2))

# rename list elements
strains <- sapply(strsplit(cov_files,"\\."),"[[",1)
names(df) <- strains

# rename columns of each data.frame
cols <- c("rname","startpos","endpos","perc_pos_covered","meandepth","meanmapq")
df <- lapply(df,setNames,cols)

# remove info of mitoDNA
df <- lapply(df, function(x) x[grep("chrMT",x[,1],value = F,invert = T),])

# reshape the columns for the plots
df <- lapply(df,add_columns)

df <- lapply(df, function(x) {
  colnames(x)[7] <- "strain"
  x
})

# ggplot2 and save the output to a single pdf
plotPath <- file.path(paste0(outDir,"/all_strains.speciescomponent_MQ.pdf"))
pdf(file = plotPath, width = 12, height = 8)
lapply(df, plot_fun_MQ)
dev.off()

# ggplot2 and save the output to a single pdf
plotPath <- file.path(paste0(outDir,"/all_strains.speciescomponent_PPC.pdf"))
pdf(file = plotPath, width = 12, height = 8)
lapply(df, plot_fun_BC)
dev.off()

### segmentation ----
#Io partirei così:
# segmentazione con baseline per species
# dopo, facio una tabella riassuntiva con coverage medio per species
# solo dopo confronto species tra loro
seg_dt_final <- data.frame()
for (i in 1:length(df)) {
  # prendo il data.frame del campione 1
  x <- as.data.table(df[[i]])
  
  # prendo il segnale di una specie alla volta
  for (j in refs) {
    print(paste0(names(df)[i],": ",j))
    x1 <- x[species == j]
    # tengo solo le colonne che mi interessano di piu
    x1 <- x1[, .(chr, startpos, endpos, meandepth)]
    x1[, chr := as.character(chr)]
    setorder(x1, chr, startpos)
    
    ## devo definire una bseline del coverage
    ## decido che la baseline deve essere la moda ovviamente
    ## levando i valori a 0 senno' in alcune specie sara' zero
    ## al valore baseline aggiungo un val ridocolo per evitare divisioni a 0
    vals <- x1$meandepth[x1$meandepth > 5]
    if (length(vals) == 0 || all(is.na(vals))) next
    baseline <- median(round(vals, 1))   # IMPORTANTISSIMO: arrotonda
    # creo una colonna con il log2 ratio 
    ## cioe'il log2 di mean_depth diviso la baseline   
    x1[, log2ratio := log2((meandepth + 0.000000001) / (baseline + 0.000000001))]
    
    # Ora uso CNA 
    cna <- CNA(genomdat = x1$log2ratio,chrom = x1$chr,maploc = x1$startpos,data.type = "logratio")
    ## creo i segmenti 
    seg <- segment(cna,verbose = 1,alpha = 0.01,min.width = 2, undo.splits = "sdundo",undo.SD = 0.8)
    seg_dt <- as.data.table(seg$output)
    
    colnames(x1)[1] <- "chrom"
    
   plot_segment <-  ggplot(x1, aes(x = startpos, y = log2ratio)) +
      geom_line(linewidth = 0.3) +
      geom_hline(yintercept = 0, color = "red") +
     geom_hline(yintercept = 0, color = "red") +
     geom_hline(yintercept = 0, color = "red") +
      geom_segment(data = seg_dt,aes(x = loc.start,xend = loc.end,y = seg.mean,yend = seg.mean),inherit.aes = FALSE,
      color = "blue",linewidth = 1) +
      facet_wrap(~ chrom, scales = "free_x") +
      theme_bw() +
      labs(subtitle = paste0(names(df)[i],"_",j)) +
     coord_cartesian(ylim = c(-3, 3))
   
   plotPath <- file.path(paste0(outDir,"/",names(df)[i],".seg.spp_",j,".pdf"))
   pdf(file = plotPath, width = 10, height = 5)
   plot(plot_segment)
   dev.off()
   
   seg_dt[, approx_ratio := 2^seg.mean]
   seg_dt[,sample := names(df)[i]]
   seg_dt[,spp := j]
   seg_dt$ID <- NULL
   seg_dt_final <- rbind(seg_dt_final,seg_dt)
  }
  fwrite(seg_dt_final,file = paste0(outDir,"/allsegments.table.txt"),append = F,quote = F,sep = "\t",col.names = T,row.names = F)
}
