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
> Added the moda of the coverage to better visualize coverage changes across the chromosomes;
>
> Reduce the y limit value to better enphasize diffences now 2.5 x median value excluding bin with less 5X;
>
> Added coverage segmentation [DNAcopy package](https://bioconda.github.io/recipes/bioconductor-dnacopy/README.html)
>
> Mappability and GC content files for 1 kb windows are already provided in rep. If you change the window size, you **must** uncomment the genmap and binner script script in sppcomp_runner at lines 11 and 13

## *Saccharomyces* species composition (sppComp)

An automated, modular computational framework for a rapid glimpse of the species composition and genomic features of *Saccharomyces* yeasts from large datasets of paired-end Illumina reads, adapted to handle different computational resources.

SppComp is released as part of the [SGRP5 project]().

SppComp allows the detection of:

- hybrids composition, 
- hybrid ploidy,
- introgressed DNA,
- aneuploidies and copy number variations (CNVs) (relative copy number).

## Description
  
The species composition of *Saccharomyces* strains plays a major role in biological studies, providing valuable insights into the evolutionary history of the *genus* while being exploited to improve industrial phenotypes. Short-read sequencing is the most popular choice for large-scale genomics projects due to its rapid processing and affordable cost. As a leading model organism, *Saccharomyces* yeasts have been massively sequenced using Illumina short-read platforms. **SppComp** takes advantage of chromosome-level, end-to-end genome assemblies from the [ScRAPdb](https://www.evomicslab.org/db/ScRAPdb), and competitive short-read mapping, as implemented and described in [MuLo-YDH](https://bitbucket.org/lt11/muloydh/src/master/), to assess the species composition of *Saccharomyces* yeasts from large datasets of paired-end Illumina reads. **SppComp** is written in Bash and R. By means of the implementation of state-of-the-art software, [functional programming](http://adv-r.had.co.nz/Functional-programming.html) and [vectorized code](https://adv-r.hadley.nz/perf-improve.html#vectorise), **SppComp** reduces computational slowdowns.

#### Interpreting segmentation table

<table align="center">
  <thead>
    <tr>
      <th align="center">Ploidy</th>
      <th align="center">Baseline CN</th>
      <th align="center">Gain</th>
      <th align="center">Fold change</th>
      <th align="center">log2</th>
    </tr>
  </thead>
  <tbody>
    <tr><td align="center">Haploid</td><td align="center">1</td><td align="center">2</td><td align="center">2×</td><td align="center">1.00</td></tr>
    <tr><td align="center">Diploid</td><td align="center">2</td><td align="center">3</td><td align="center">1.5×</td><td align="center">~0.58</td></tr>
    <tr><td align="center">Triploid</td><td align="center">3</td><td align="center">4</td><td align="center">1.33×</td><td align="center">~0.42</td></tr>
    <tr><td align="center">Tetraploid</td><td align="center">4</td><td align="center">5</td><td align="center">1.25×</td><td align="center">~0.32</td></tr>
  </tbody>
</table>

<br>

<table align="center">
  <thead>
    <tr>
      <th align="center">Ploidy</th>
      <th align="center">Baseline CN</th>
      <th align="center">Loss</th>
      <th align="center">Fold change</th>
      <th align="center">log2</th>
    </tr>
  </thead>
  <tbody>
    <tr><td align="center">Diploid</td><td align="center">2</td><td align="center">1</td><td align="center">0.5×</td><td align="center">-1.00</td></tr>
    <tr><td align="center">Triploid</td><td align="center">3</td><td align="center">2</td><td align="center">0.67×</td><td align="center">~-0.58</td></tr>
    <tr><td align="center">Tetraploid</td><td align="center">4</td><td align="center">3</td><td align="center">0.75×</td><td align="center">~-0.42</td></tr>
  </tbody>
</table>

## Download

```sh
https://github.com/nicolo-tellini/sppComp.git

cd sppComp

git clone https://github.com/nicolo-tellini/rust_cov_bed

cd rust_cov_bed

cargo build --release

cd ..

```

## Content

:open_file_folder: :

```{bash}
.
├── rep
├── misc
├── tmp
├── rust_cov_bed
├── scr
└── seq
```
## Installation

```{bash}
mamba create -n sppcomp \
    minimap2=2.28 \
    samtools=1.21 \
    genmap=1.3.0 \
    bedtools=2.31.1 \
    gawk=5.3.1 \
    parallel=20240722 \
    r-base=4.4.1 \
    r-ggplot2=3.5.2 \
    r-data.table=1.15.4 \
    r-tidyverse=2.0.0 \
    bioconductor-biostrings=2.74.0 \
    bioconductor-genomicranges=1.58.0 \
    bioconductor-dnacopy \
    -c conda-forge -c bioconda
```
Activate the environment:

```{bash}
mamba activate sppcomp
```

:warning: :warning: :warning: Mappability and GC content files for 1 kb windows are already provided in rep. If you change the window size, you **must** uncomment the genmap and binner script script in sppcomp_runner at lines 11 and 13

## more about ...

:warning:  [The Assemblies](https://github.com/nicolo-tellini/sppComb/blob/main/assemblies.md)

:heavy_check_mark: [Competitive mapping](https://academic.oup.com/mbe/article/36/12/2861/5545524?login=false)

:warning: [The Implementation](https://github.com/nicolo-tellini/sppComb/blob/main/deepintothecode.md)

:heavy_check_mark: [Testing](https://github.com/nicolo-tellini/sppComp/blob/main/misc/testing.md)

:warning:  [Organisation of the directories](https://github.com/nicolo-tellini/sppComb/blob/main/dirtree.md)


## Example

CBS 2834 3n S.cer x S. kud x S.uva sample with complex aneuploidies and species combinations.

<img width="1566" height="1056" alt="Screenshot from 2026-04-12 15-25-11" src="https://github.com/user-attachments/assets/ea64af8d-356e-484a-abb1-c51b0a20a3ca" />

Signal segmentation CBS 2834

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-03-43" src="https://github.com/user-attachments/assets/a93392cb-0a3a-48e6-8a4a-7750279375aa" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-04-11" src="https://github.com/user-attachments/assets/55cf7609-b58f-4628-b120-b0b586eb2848" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-04-42" src="https://github.com/user-attachments/assets/3a45497c-8e12-4c18-986c-25af535b4e00" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-05-10" src="https://github.com/user-attachments/assets/3505a3ac-2459-493d-a9c4-6748ea72a73b" />

## Release history

* v1.0.1 Realeased in 2026
* v1.0.0 Released in 2023
  
## Citations

Please, if you use this pipeline, cite this repo.
