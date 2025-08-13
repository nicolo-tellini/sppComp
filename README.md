<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComp/blob/main/misc/g1154.png" alt="sppComb logo" width="450" height="300"/> 
</p>

© logo nt & Chiara Vischioni

[![Licence](https://img.shields.io/github/license/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/sppComp/releases/tag/v.1.0.0)
[![release date](https://img.shields.io/github/release-date/nicolo-tellini/sppComp-SGRP5?color=violet&style=plastic)](https://github.com/nicolo-tellini/sppComp/releases/tag/v.1.0.0)
[![commit](https://img.shields.io/github/last-commit/nicolo-tellini/sppComp-SGRP5?color=yellow&style=plastic)](https://github.com/nicolo-tellini/sppComp/graphs/commit-activity)

## *Saccharomyces* species composition (sppComp)

An automated modular computational framework for a rapid glympse to the species composition and genomics features of *Saccharomyces* yeasts from large datasets of paired-end illumina reads, adtapt to deal different computational resourses.

SppComp is realeased as part of the (SGRP5 project)[]. 

SppComp allows the detection of: 

- hybrids
- hybrid ploidy (3n and 4n [3n + n])
- introgressed DNA
- aneuploidies (relative number)
- copy number variations (CNVs)

## Description
  
The species composition of *Saccharomyces* strains plays a major role in biological studies providing valuable insights in the evolutionary history of the *genus* while being exploited for improving indutrial phenotypes. Short-read sequencing are the most popular choice for large-scale genomics projects due to their rapid processesing and affordable prices. As a leading model organisms, the *Saccharomyces* yeasts, heve been massively sequenced with short reads Illumina platfroms. **SppComp** takes advantage of the chromosome-level end-to-end genome assemblies produced/reannotated with [LRSDAY](https://github.com/yjx1217/LRSDAY), SCrapDB and competitive short read mapping, as implemented and described in [MuLo-YDH](https://bitbucket.org/lt11/muloydh/src/master/), to assess the species composition of *Saccharomyces* yeasts from large datasets of paired-end illumina reads. **SppComp** is written in bash and R. By means the implementation of state-of-the-art softwares, [functional programming](http://adv-r.had.co.nz/Functional-programming.html), [vectorised code](https://adv-r.hadley.nz/perf-improve.html#vectorise), **SppComp** reduces computational slowdowns, allowing a full control of the processes.

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComp/blob/main/misc/sppComp.flow.png2" alt="sppComb flow"/>
</p>

## Download

```sh
git clone https://github.com/nicolo-tellini/sppComb.git

cd sppComb
```

## Content

:open_file_folder: :

```{bash}
.
├── rep
├── misc
├── scr
└── seq
```

SppComp runner is provided in two different constructs:

- ```sppComp.sh``` : a bash script for CLI use
- ```sppComp.Rmd``` : a Rmarkdown script for GUI use (Rstudio)

Both the constructs run the same scripts but while ```sppComp.sh``` allows an agile editing from CLI it remains more suitable for large datasets on a server computer. On the other hand, ```sppComp.Rmd``` is recommended for people that prefer the use of the GUI. ```sppComp.Rmd``` ends with the generation of a report (HTML/PDF) which better fit with a run of a few samples.

## more about ...

:warning:  [The Assemblies](https://github.com/nicolo-tellini/sppComb/blob/main/assemblies.md)

:heavy_check_mark: [Competitive mapping](https://academic.oup.com/mbe/article/36/12/2861/5545524?login=false)

:warning: [The Implementation](https://github.com/nicolo-tellini/sppComb/blob/main/deepintothecode.md)

:warning: [Testing](https://github.com/nicolo-tellini/sppComb/blob/main/testing.md)

:warning:  [Organisation of the directories](https://github.com/nicolo-tellini/sppComb/blob/main/dirtree.md)

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
* [Polychrome](https://www.rdocumentation.org/packages/Polychrome/versions/1.5.1)
* [stringi](https://www.rdocumentation.org/packages/stringi/versions/1.7.12)
* [dplyr](https://www.rdocumentation.org/packages/dplyr/versions/1.0.10)
* [rstudioapi](https://rstudio.github.io/rstudioapi/) [if you use the Rmd only]

## Citations
