# SppComp

**SppComp: Saccharomyces species composition**

An automated and flexible computational framework for a rapid glympse to the species composition of *Saccharomyces* yeasts from large datasets of paired-end illumina reads adtapt to deal different computational resourses.

## Description
  
The species composition of *Saccharomyces* strains plays a major role in biological studies providing valuable insights in the evolutionary history of the *genus* while being exploited for improving indutrial phenotypes. Short-read sequencing are the most popular choice for large-scale genomics projects due to their rapid processesing and affordable prices. As a leading model organisms, the *Saccharomyces* yeasts, heve been massively sequenced with short reads Illumina platfroms. However, integrating several short-read sequencing data from different projects may generate workflow bottlenecks slowing down genomic analysises. Here we present **SppComp**, a modular computational pipeline that takes advange of the chromosome-level end-to-end genome assemblies produced/reannotated with [LRSDAY](https://github.com/yjx1217/LRSDAY) and released elsewhere to assess the species composition of *Saccharomyces* yeasts from large datasets of paired-end illumina reads. **SppComp** is written in bash and R. By means the implementation of state-of-the-art softwares, [functional programming](http://adv-r.had.co.nz/Functional-programming.html), [vectorised code](https://adv-r.hadley.nz/perf-improve.html#vectorise) and silly-billy (but effective) bash tricks,  **SppComp** reduces computational slowdowns, allowing a full control of the processes to the user who can  setup easily the run based on the computational resourses available and skip steps, where appropriate.

The mantra is:
> "Make it work, make it right, make it fast."<br />

cit. Kent Beck

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComb/blob/main/sppComp.flow.png" alt="sppComb flow"/>
</p>

## Organised directory structure
```{bash}
.
├── seq
├── rep
├── cps
├── scr
└── runner.sh
```
*seq* stores paired-end illumina <code>fastq</code> files of the samples to process.<br /> The <code>fastq</code> files **must** be named: <code>samplename.R1.fastq.gz</code> and <code>samplename.R2.fastq.gz</code>.<br /> 
*rep* stores the reference ```saccharomyces_all_assemblies.fa``` genome, a concatenation of eight *de novo* chromosome-level end-to-end genome assemblies, one for each *Saccharomyces* species today known.;<br />
At the end of the run, *cps* (that stands for *checkpoints*) hosts two *txt* files: <code>BWA.cps.txt</code> and <code>COV.cps.txt</code>. The name of the samples will be printed inside these two files at the end of STEP1 and STEP3, respectivelly. Sample names stored in these files prevent the pipeline to take them in consideration a second time. This allow the user to:
* rerun only specifc sample (removing the sample names from <code>BWA.cps.txt</code> and <code>COV.cps.txt</code> or one of he two), 
* restart the run in case the pipeline ends with errors, 
* add a new batch of samples inside *seq* and run the pipeline (this times will process only the newly added samples ignoring the old ones because the sample names are not stored inside <code>BWA.cps.txt</code> and <code>COV.cps.txt</code>, yet).

*scr*: scripts


At the end of the run, *cps* . 
Both the files stored the name of the samples after the mapping with BWA and the extraction of the coverage will be successfully completed. 



## Release history

* v1.0.0 Released on 2023


## Requirements
### Hardware, operating system and network
This protocol is designed for a desktop or computing server running an x86-64-bit Linux operating system. Multithreaded processors are preferred to speed up the process since many steps can be configured to use multiple threads in parallel. For assembling and analyzing the budding yeast genomes (genome size = ~12.5 Mb), at least 16 Gb of RAM and 100 Gb of free disk space are recomended. When adapted for other eukaryotic organisms with larger genome sizes, the RAM and disk space consumption will scale up, majorly during *de novo* genome assembly (performed by [Canu](https://github.com/marbl/canu) by default. Plese refer to [Canu’s manual](http://canu.readthedocs.io/en/latest/) for suggested RAM and disk space consumption for assembling large genomes. Stable Internet connection is required for the installation and configuration of LRSDAY as well as for retrieving the test data.

see also [#3]()

### Softwares
* [samtools](https://github.com/samtools/samtools/releases) v1.10 or higher
* [bwa](https://github.com/lh3/bwa/releases)

### R packages
* [Biostrings](https://www.bioconductor.org/packages/release/bioc/html/Biostrings.html)
* [GenomicRanges](https://www.bioconductor.org/packages/release/bioc/html/GenomicRanges.html)
* [data.table](https://rdocumentation.org/packages/data.table/versions/1.14.2)
* [ggplot2](https://ggplot2.tidyverse.org/)

## Citations
