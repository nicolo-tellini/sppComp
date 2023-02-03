# SppComp

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComp/blob/main/misc/g3940.png" alt="sppComb logo" width="450" height="300"/> 
</p>

© N.T. & PhD Chiara Vischioni
 
:bangbang::bangbang:  PAGE UNDER CONSTRUCTION :bangbang::bangbang:

:shipit: - (code not available)

[![Licence](https://img.shields.io/github/license/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/releases/tag/v.1)
[![release date](https://img.shields.io/github/release-date/nicolo-tellini/sppComp-SGRP5a?color=violet&style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/releases/tag/v.1)
[![commit](https://img.shields.io/github/last-commit/nicolo-tellini/sppComp-SGRP5?color=yellow&style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/graphs/commit-activity)

**SppComp: Saccharomyces species composition**

An automated modular computational framework for a rapid glympse to the species composition and genomics features of *Saccharomyces* yeasts from large datasets of paired-end illumina reads, adtapt to deal different computational resourses.

SppComp is realeased as part of the (SGRP5 project)[]. 

SppComp allows the detection of: 

- hybrids
- hybrid ploidy (3n and 4n [3n + n])
- introgressed DNA
- aneuploidies (relative number)
- copy number variations (CNVs)

## Description
  
The species composition of *Saccharomyces* strains plays a major role in biological studies providing valuable insights in the evolutionary history of the *genus* while being exploited for improving indutrial phenotypes. Short-read sequencing are the most popular choice for large-scale genomics projects due to their rapid processesing and affordable prices. As a leading model organisms, the *Saccharomyces* yeasts, heve been massively sequenced with short reads Illumina platfroms. However, integrating several short-read sequencing data from different projects may generate workflow bottlenecks slowing down genomic analysises. **SppComp**, a modular computational pipeline, takes advantage of the chromosome-level end-to-end genome assemblies produced/reannotated with [LRSDAY](https://github.com/yjx1217/LRSDAY) and competitive short read mapping, as implemented and described in [MuLo-YDH](https://bitbucket.org/lt11/muloydh/src/master/), to assess the species composition of *Saccharomyces* yeasts from large datasets of paired-end illumina reads. **SppComp** is written in bash and R. By means the implementation of state-of-the-art softwares, [functional programming](http://adv-r.had.co.nz/Functional-programming.html), [vectorised code](https://adv-r.hadley.nz/perf-improve.html#vectorise) and effective silly-billy bash tricks, **SppComp** reduces computational slowdowns, allowing a full control of the processes along with the possibility to skip steps, where appropriate.

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComp/blob/main/misc/sppComp.flow.png2" alt="sppComb flow"/>
</p>

## Download

```sh
git clone https://github.com/nicolo-tellini/sppComb.git

cd sppComb
```

SppComp runner is provided in two different constructs:

- ```sppComp.sh``` : a bash script for CLI use
- ```sppComp.Rmd``` : a Rmarkdown script for GUI use (Rstudio)

Both the constructs run the same scripts but while ```sppComp.sh``` allows an agile editing from CLI it remains more suitable for large datasets on a server computer. On the other hand, ```sppComp.Rmd``` is recommended for people that prefer the use of the GUI. ```sppComp.Rmd``` ends with the generation of a report (HTML/PDF) which better fit with a run of a few samples.

## How to run:

- sppComp.sh
1) Edit the variables on the top of the file dedicated to the user.
  ```sh 
  #!/bin/bash
  
  binsize=10000 # windows size
  nSamples=4 # number of samples
  nThreads=1 # per-sample number of threads
  ```
  2) run 

  ```sh 
    nohup bash sppComp.sh &
  ```

- sppComp.Rmd

 1) Open Rstudio
 2) File > Open File... > Browse to sppComp.Rmd 
 3) Edit the user's settins 
 ```r
  binsize=10000
  nSamples=4 # number of samples
  nThreads=1 # per-sample number of threads 
  ```
  4) Knit > PDF or HTML
 
 The code is evaluated by default.
 
 The default variables are the same as reported above. 

## Output

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComb/blob/main/misc/CBS2834_profile.png" alt="Sublime's custom image" width="1200" height="700"/>
</p>

## FIND OUT more about 

:heavy_check_mark: [The Assemblies](https://github.com/nicolo-tellini/sppComb/blob/main/assemblies.md)

:heavy_check_mark: [Competitive mapping](https://academic.oup.com/mbe/article/36/12/2861/5545524?login=false)

:warning: [The Implementation](https://github.com/nicolo-tellini/sppComb/blob/main/deepintothecode.md)

:warning: [Testing](https://github.com/nicolo-tellini/sppComb/blob/main/testing.md)

:heavy_check_mark: [Organisation of the directories](https://github.com/nicolo-tellini/sppComb/blob/main/dirtree.md)

## Release history

* v1.0.0 Released in 2023

## Dependencies

Software

* [samtools](https://github.com/samtools/samtools/releases) v1.10 or higher
* [bwa](https://github.com/lh3/bwa)
* [gawk](https://www.gnu.org/software/gawk) v5.0.0 or higher

R libraries
* [Biostrings](https://www.bioconductor.org/packages/release/bioc/html/Biostrings.html)
* [GenomicRanges](https://www.bioconductor.org/packages/release/bioc/html/GenomicRanges.html)
* [data.table](https://rdocumentation.org/packages/data.table/versions/1.14.2)
* [ggplot2](https://ggplot2.tidyverse.org/)
* [rstudioapi](https://rstudio.github.io/rstudioapi/) [if you use the Rmd only]

## Citations
