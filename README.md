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
  
The species composition of *Saccharomyces* strains plays a major role in biological studies providing valuable insights in the evolutionary history of the *genus* while being exploited for improving indutrial phenotypes. Short-read sequencing are the most popular choice for large-scale genomics projects due to their rapid processesing and affordable prices. As a leading model organisms, the *Saccharomyces* yeasts, heve been massively sequenced with short reads Illumina platfroms. **SppComp**, a modular computational pipeline, takes advantage of the chromosome-level end-to-end genome assemblies produced/reannotated with [LRSDAY](https://github.com/yjx1217/LRSDAY) and competitive short read mapping, as implemented and described in [MuLo-YDH](https://bitbucket.org/lt11/muloydh/src/master/), to assess the species composition of *Saccharomyces* yeasts from large datasets of paired-end illumina reads. **SppComp** is written in bash and R. By means the implementation of state-of-the-art softwares, [functional programming](http://adv-r.had.co.nz/Functional-programming.html), [vectorised code](https://adv-r.hadley.nz/perf-improve.html#vectorise) and effective silly-billy bash tricks, **SppComp** reduces computational slowdowns, allowing a full control of the processes along with the possibility to skip steps, where appropriate.

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
├── sppComp.Rmd
├── sppComp.sh
├── scr
└── seq
```

SppComp runner is provided in two different constructs:

- ```sppComp.sh``` : a bash script for CLI use
- ```sppComp.Rmd``` : a Rmarkdown script for GUI use (Rstudio)

Both the constructs run the same scripts but while ```sppComp.sh``` allows an agile editing from CLI it remains more suitable for large datasets on a server computer. On the other hand, ```sppComp.Rmd``` is recommended for people that prefer the use of the GUI. ```sppComp.Rmd``` ends with the generation of a report (HTML/PDF) which better fit with a run of a few samples.

## Assembly preparation from CLI

Example with [human genome](https://www.ncbi.nlm.nih.gov/data-hub/genome/GCF_000001405.40/) GRCh38.p14.

1. rename the fasta with a TAG, like human:

 ```{bash}
 mv GCF_000001405.40_GRCh38.p14_genomic.fna human.genome.fa
 ```
If you ```grep ">" human.genome.fa``` you can see there are scaffolds and PATCHES, we do not want them.

2. move the sequences at the same line of the corrsponding fasta entries. [Pierre Lindenbaum](https://www.biostars.org/u/30/)'s solution:

 ```{bash}
 awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' < human.genome.fa > human.genome2.fa
 ```
3. grep out scaffolds and PATCHES

 ```{bash}
 grep -Ev "scaffold|PATCHES" human.genome2.fa > human.genome3.fa
 ```

4. move the sequences back one line below the entries

 ```{bash}
 cat human.genome3.fa | tr '\t' '\n' > human.genome4.fa
 ```
If you ```grep ">" human.genome4.fa``` you can see there are not nor scaffolds or PATCHES anymore.

5. rename the fasta entries. This can be done in several different ways (as all the steps above). What follow is an example that work fine with the name of the entries in human. At this step we need to respect the naming format: chr[...]_[TAG]. Keeping in mind that the last three are X, Y and MT we can replace chromosomes names with numbers:

 ```{bash}
 tr -d '[:blank:]' < human.genome4.fa > human.genome5.fa
 k=1
 for j in $(grep ">" human.genome5.fa)
 do
 newname=$(echo ">chr"$k"_human")
 sed -i "s+$j+$newname+g" human.genome5.fa
 ((k=k+1))
 done
 sed -i 's+>chr23_human+>chrX_human+g' human.genome5.fa 
 sed -i 's+>chr24_human+>chrY_human+g' human.genome5.fa 
 sed -i 's+>chr25_human+>chrMT_human+g' human.genome5.fa 
 ```
 
6. remove intermediate files and rename human.genome5.fa as human.genome.fa
 
 ```{bash}
 rm human.genome.fa human.genome2.fa human.genome3.fa human.genome4.fa 
 
 mv human.genome5.fa human.genome.fa
 ```
7. ```grep ">" human.genome.fa``` will show the following output:

 ```{bash}
 >chr1_human
 >chr2_human
 >chr3_human
 >chr4_human
 >chr5_human
 >chr6_human
 >chr7_human
 >chr8_human
 >chr9_human
 >chr10_human
 >chr11_human
 >chr12_human
 >chr13_human
 >chr14_human
 >chr15_human
 >chr16_human
 >chr17_human
 >chr18_human
 >chr19_human
 >chr20_human
 >chr21_human
 >chr22_human
 >chrX_human
 >chrY_human
 >chrMT_human
 ```
 
 8. repeat the same steps for all the assemblies.
 
## the fastqs

Move the fastws inside ```./seq/```. The fastqs **must** be gziped and suffixed \_1.fastq.gz and \_2.fastq.gz.

## how to run:

- sppComp.sh
1) Edit the variables on the top of the file dedicated to the user.
  ```sh 
  #!/bin/bash
  
  binsize=10000 # windows size
  nSamples=2 # number of samples
  nThreads=2 # per-sample number of threads
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
  nSamples=2 # number of samples
  nThreads=2 # per-sample number of threads 
  ```
  4) Knit > [PDF](https://github.com/nicolo-tellini/sppComp/blob/main/misc/sppComp.pdf) or [HTML](https://htmlpreview.github.io/?https://github.com/nicolo-tellini/sppComp/blob/main/misc/sppComp.html)
 
 The code is evaluated by default.
 
 The default variables are the same as reported above. 
 
## window-based coverage plot

## marker-based coverage plot

## marker-based interactive plot of minor species components

## data interpretation: the case of SNP1 (YIL061C) and the "matryoshka" introgressed DNA

It happened to me to inspect a marker-based interactive plot of the minor species components of the *Saccharomyces cerevisiae* alpechin strain named A8 and to identify a spike of coverage against the *Saccharomyces mikatae* assembly (IFO 1815). This seemed somewhat surprising at the beginning by reason of the fact that the spike is located in the middle of a larger introgressed segments inherited from the European *Saccharomyces paradoxus* ("matryoshka" introgressed DNA)[1]. The snapshot depicts the event: 

My first guess was that the gene underlying the spike (YIL061C alias SNP1) was not present in the *Saccharomyces paradoxus* whole-genome assembly used in the competitive mapping (YPS 138, an American *Saccharomyces paradoxus*) and that, in the absence of a *Saccharomyces paradoxus* copy, the short reads would have mapped against the most similar copy (the copy of *Saccharomyces mikatae*, in this case). But it turned out that the gene function of SNP1 (pre-mRNA maturation) is so conserved that orthologs can be detected up to mammals (SNRNP70 in humans). In fact, SNP1 was also present in the assembly of the American *Saccharomyces paradoxus*. 
By the construction of the phylogeny we finally observed that the signal we detected was instead due to the fact that IFO 1815 (and all the *Saccharomyces mikatae* strains isolated so far[2]) inherited a SNP1 copy from an Euroasiatic *Saccharomyces paradoxus* (ancestral introgression) so that the copy of SNP1 in the Alpechin A8 (inherited from the European *Saccharomyces paradoxus*) is genetically closer to the copy of IFO 1815 rather than to the American *Saccharomyces paradoxus* YPS 138. This justifying the signal of coverage against the *Saccharomyces mikatae* assembly.  

#### The take-home message 
The pipeline employs a competitive mapping strategy against whole-genome assemblies, which, akin to all reference-based methods, is subject to reference bias. Therefore, caution should be exercised when interpreting the results derived from genomic assemblies, and complementary approaches should be employed to provide additional evidence and validation.

[1] note: the alpechin *Saccharomyces cerevisiae* strains are known to be permeated by *Saccharomyces paradoxus* DNA. *Tellini et al. 2023* and *Pontes et al. 2019*  
[2] find more about this here 

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
