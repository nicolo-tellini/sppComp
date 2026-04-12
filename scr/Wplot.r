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

mode1 <- function(v) {
  v <- v[is.finite(v)]
  if (length(v) < 10 || length(unique(v)) < 2) return(NA_real_)
  d <- density(v)
  d$x[which.max(d$y)]
}

top2_peaks <- function(v, min_rel = 0.3) {
  v <- v[is.finite(v)]
  if (length(v) < 10 || length(unique(v)) < 2) return(data.table(x = NA_real_, rank = NA_integer_))
  
  d <- density(v)
  i <- which(diff(sign(diff(d$y))) == -2) + 1
  if (!length(i)) i <- which.max(d$y)
  
  p <- data.table(x = d$x[i], y = d$y[i])
  p <- p[y >= max(y) * min_rel]
  if (!nrow(p)) p <- data.table(x = d$x[which.max(d$y)], y = max(d$y))
  
  setorder(p, -y)
  p[1:min(2, .N), .(x, rank = seq_len(.N))]
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

plot_density_cov <- function(x, binsize, sample_name) {
  
  dt5 <- as.data.table(x)[is.finite(meandepth) & meandepth > 5]  # filter once
  
  dt5_plot <- dt5[, {  # remove extreme outliers per species × chr
    q1 <- quantile(meandepth, 0.25, na.rm = TRUE)
    q3 <- quantile(meandepth, 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    .SD[meandepth >= (q1 - 1.5 * iqr) & meandepth <= (q3 + 1.5 * iqr)]
  }, by = .(species, chr)]
  
  global_dt <- dt5_plot[, .(x = mode1(meandepth), line_type = "Global species mode"), by = species]
  peaks_dt <- dt5_plot[, top2_peaks(meandepth), by = .(species, chr)]
  peaks_dt[rank == 1, line_type := "Main chromosome peak"]
  peaks_dt[rank == 2, line_type := "Secondary chromosome peak"]
  
  ggplot(dt5_plot, aes(meandepth)) +
    geom_density(linewidth = 0.3, color = "black") +
    geom_vline(data = peaks_dt[rank == 1 & is.finite(x)], aes(xintercept = x, color = line_type, linetype = line_type), alpha = 0.9) +
    geom_vline(data = peaks_dt[rank == 2 & is.finite(x)], aes(xintercept = x, color = line_type, linetype = line_type), alpha = 0.9) +
    geom_vline(data = global_dt[is.finite(x)], aes(xintercept = x, color = line_type, linetype = line_type),alpha = 0.9) +
    scale_color_manual( name = "Lines",
      values = c( "Main chromosome peak" = "blue","Secondary chromosome peak" = "darkgreen","Global species mode" = "red")
    ) +
    scale_linetype_manual(name = "Lines",values = c("Main chromosome peak" = 1,"Secondary chromosome peak" = 2,"Global species mode" = 3)
    ) +
    facet_grid(rows = vars(species), cols = vars(chr), scales = "free_y") +
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      axis.title.x = element_blank(),
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      axis.ticks.x = element_blank(),
      text = element_text(size = 12, colour = "black"),
      axis.text.y = element_text(size = 12, colour = "black"),
      legend.position = "bottom"
    ) +
    ggtitle(paste0("sample: ", sample_name))
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

# density  plot distribution  
plotPath <- file.path(paste0(outDir,"/all_strains.densityplot.pdf")) 
pdf(file = plotPath, width = 12, height = 8)
for (i in seq_along(df)) {
  p <- plot_density_cov(df[[i]], binsize, names(df)[i])
  print(p)
}
dev.off()
