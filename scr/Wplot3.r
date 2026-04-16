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
 # binsize <- 5000

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
df <- lapply(cov_files,function(x) fread(cmd = paste0("cut -f1,2,3,6,7,9,10 ",baseDir,"/cov/",x),data.table = FALSE,skip=1))

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
set.seed(1234)

gc  <- fread(paste0(baseDir,"/rep/windows.gc.bed"), col.names = c("chr","start","end","gc"))
map <- fread(paste0(baseDir,"/rep/binnedGenome.",binsize,".mappability.bed"), col.names = c("chr","start","end","map"))

setkey(gc,  chr, start, end)
setkey(map, chr, start, end)

seg_dt_final <- data.table()
plot_list <- list()

for (i in seq_along(df)) {
  
  x <- as.data.table(df[[i]])
  x[, `:=`(chr = as.character(chr), species = as.character(species))]
  x[, chr_full := paste0(chr, "_", species)]
  x <- merge(x,gc[, .(chr, start, end, gc)],by.x = c("chr_full", "startpos", "endpos"),by.y = c("chr", "start", "end"),all.x = TRUE)
  x <- merge(x,map[, .(chr, start, end, map)],by.x = c("chr_full", "startpos", "endpos"),by.y = c("chr", "start", "end"),all.x = TRUE)
  x[, `:=`(gc = as.numeric(gc),map = as.numeric(map),meandepth = as.numeric(meandepth))]
  x <- x[is.finite(gc) & is.finite(map) & is.finite(meandepth) &gc >= 0.15 & gc <= 0.85 & map >= 0.80]
  
  for (j in refs) {
    
    cat(names(df)[i], j, "\n")
    
    x2 <- copy(x[species == j])
    if (nrow(x2) < 50) next
    
    setorder(x2, chr, startpos)
    
    # GC correction
    fit_gc <- tryCatch(loess(meandepth ~ gc, data = x2[meandepth > 0], span = 0.4, family = "symmetric"), error = function(e) NULL)
    
    if (is.null(fit_gc)) next
    
    x2[, gc_pred := predict(fit_gc, newdata = x2)]
    x2 <- x2[is.finite(gc_pred) & gc_pred > 0]
    if (nrow(x2) < 20) next
    
    x2[, depth_gc := meandepth / gc_pred * median(gc_pred, na.rm = TRUE)]
    
    # mappability correction
    fit_map <- tryCatch(loess(depth_gc ~ map, data = x2[depth_gc > 0], span = 0.4, family = "symmetric"),error = function(e) NULL)
    
    if (!is.null(fit_map)) {
      x2[, map_pred := predict(fit_map, newdata = x2)]
      x2 <- x2[is.finite(map_pred) & map_pred > 0]
      if (nrow(x2) < 20) next
      x2[, depth_corr := depth_gc / map_pred * median(map_pred, na.rm = TRUE)]
    } else {
      x2[, depth_corr := depth_gc]
    }
    
    # baseline
    vals <- x2$depth_corr[
      is.finite(x2$depth_corr) &
        x2$depth_corr > 1   # <-- filtro senno sti cazzi stanno tutte a 0 e si gonfia la baseline 
    ]
    
    if (length(vals) < 20) next
    
    baseline <- median(vals, na.rm = TRUE)
    if (!is.finite(baseline) || baseline <= 0) baseline <- median(vals, na.rm = TRUE)
    if (!is.finite(baseline) || baseline <= 0) next
    
    # log2 ratio
    x2[, log2ratio := log2((depth_corr + 1e-9) / (baseline + 1e-9))]
    x2 <- x2[is.finite(log2ratio)]
    if (nrow(x2) < 10) next
    
    # segmentation
    cna <- CNA(genomdat = x2$log2ratio,chrom = x2$chr,maploc = x2$startpos,data.type = "logratio")
    
    seg <- segment(smooth.CNA(cna),alpha = 0.001,min.width = 3,undo.splits = "sdundo",undo.SD = 2)
    
    seg_dt <- as.data.table(seg$output)
    seg_dt[, `:=`(sample = names(df)[i],spp = j,baseline = baseline,relative_copy_signal = 2^seg.mean)]
    seg_dt_final <- rbind(seg_dt_final, seg_dt, fill = TRUE)
    
    # plot
    plot_list[[length(plot_list) + 1]] <- {
      
      # assicuro che i nomi delle colonne siano coerenti
      seg_dt[, chr := chrom]
      
      xplot <- copy(x2)
      
      ggplot(xplot, aes(x = startpos, y = log2ratio)) +
        geom_point(size = 0.25, alpha = 0.5) +
        geom_line(linewidth = 0.2, alpha = 0.5) +
        geom_hline(yintercept = 0, color = "red") +
        geom_segment(
          data = seg_dt,aes(x = loc.start,xend = loc.end,y = seg.mean,yend = seg.mean),inherit.aes = FALSE,linewidth = 0.4) +
        facet_wrap(~ chr, scales = "free_x") +
        theme_bw() +
        labs(subtitle = paste0(names(df)[i], "_", j),x = "Chromosome position",y = "log2 ratio") +
        coord_cartesian(ylim = c(-3,3))
    }
  }
}

fwrite(seg_dt_final,file.path(outDir, "allsegments.table.txt"),sep = "\t")

pdf(file.path(outDir, "segmentationPlots.pdf"), width = 10, height = 5)
for (p in plot_list) print(p)
dev.off()
