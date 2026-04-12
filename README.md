<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComp/blob/main/misc/g1154.png" alt="sppComb logo" width="450" height="300"/> 
</p>

© logo nt & Chiara Vischioni

[![Licence](https://img.shields.io/github/license/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/S.cerevisiaeData/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/nicolo-tellini/sppComp-SGRP5?style=plastic)](https://github.com/nicolo-tellini/sppComp/releases/tag/v.1.0.0)
[![release date](https://img.shields.io/github/release-date/nicolo-tellini/sppComp-SGRP5?color=violet&style=plastic)](https://github.com/nicolo-tellini/sppComp/releases/tag/v.1.0.0)
[![commit](https://img.shields.io/github/last-commit/nicolo-tellini/sppComp-SGRP5?color=yellow&style=plastic)](https://github.com/nicolo-tellini/sppComp/graphs/commit-activity)

>[!NOTE]
> NEW:
>
> Added the moda of the coverage to better visualize coverage changes across the species;
>
> Reduce the y limit value to better enphasize diffences now 2.5 x median value excluding bin with less 5X;
>
> Added, in an experimental way, a density plot alongside the coverage plot, to complement coverge visualization;
>
>> In the density plot, the black lines show the distribution of sequencing coverage for each chromosome within each species across windows. The solid blue line marks the main coverage peak for that chromosome, the dashed green line (if present) marks a second coverage peak (agnitude at least 30% of the main peak) indicating an additional group of regions with different coverage (possibly suggesting mixed signals emerging, for example, from complex aneuploidy, like chromosome III (see below section examples)), and the dashed red line shows the overall coverage level for the entire species as a baseline. By comparing these lines, you can see whether a chromosome behaves like the rest of the genome (blue ≈ red) or deviates from it (blue shifted), and whether there is evidence of multiple coverage states within the same chromosome.

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

:heavy_check_mark: [Testing](https://github.com/nicolo-tellini/sppComp/blob/main/misc/testing.md)

:warning:  [Organisation of the directories](https://github.com/nicolo-tellini/sppComb/blob/main/dirtree.md)

## Release history

* v1.0.0 Released in 2023

## Dependencies
```{bash}
mamba create -n sppcomp \
    minimap2=2.28 \
    samtools=1.21 \
    gawk=5.3.1 \
    parallel=20240722 \
    r-base=4.4.1 \
    r-ggplot2=3.5.2 \
    r-data.table=1.15.4 \
    r-tidyverse=2.0.0 \
    bioconductor-biostrings=2.74.0 \
    bioconductor-genomicranges=1.58.0 \
    -c conda-forge -c bioconda
```
Activate the environment:

```{bash}
mamba activate sppcomp
```

## Example

CFS an high coverage 3n S. cerevisiae sample with aneuploidies (+1 chrII; -1 chrVI and complex event on chrIII).

<img width="1566" height="1056" alt="Screenshot from 2026-04-12 15-20-42" src="https://github.com/user-attachments/assets/2bd5aa4b-3038-4e54-9f99-3f2e1a7189d4" />

<img width="1576" height="1052" alt="Screenshot from 2026-04-12 15-35-12" src="https://github.com/user-attachments/assets/95d605d7-873c-41e1-a741-a3e5732482b2" />


CBS 2834 a mid coverage 3n S.cer x S. kud x S.uva sample with complex aneuploidies and species combinations.

<img width="1566" height="1056" alt="Screenshot from 2026-04-12 15-25-11" src="https://github.com/user-attachments/assets/ea64af8d-356e-484a-abb1-c51b0a20a3ca" />

<img width="1576" height="1052" alt="Screenshot from 2026-04-12 15-33-18" src="https://github.com/user-attachments/assets/1e5fdeb0-90ea-47be-b1ad-cfc37a72c31b" />



## Citations
Please, if you use this pipeline, cite this repo.
