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
> Added coverage segmentation see [segmentation](#segmentation)

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

## more about ...

:warning:  [The Assemblies](https://github.com/nicolo-tellini/sppComb/blob/main/assemblies.md)

:heavy_check_mark: [Competitive mapping](https://academic.oup.com/mbe/article/36/12/2861/5545524?login=false)

:warning: [The Implementation](https://github.com/nicolo-tellini/sppComb/blob/main/deepintothecode.md)

:heavy_check_mark: [Testing](https://github.com/nicolo-tellini/sppComp/blob/main/misc/testing.md)

:warning:  [Organisation of the directories](https://github.com/nicolo-tellini/sppComb/blob/main/dirtree.md)

# Segmentation 
This step identifies genomic regions with consistent deviations in coverage relative to a baseline.

For each sample × species:

1. Compute a baseline coverage as the median of windows with `meandepth > 5`.

2. Convert coverage to log-scale:  
   `log2ratio = log2(meandepth / baseline)`

3. Apply CBS segmentation (`DNAcopy::segment`) to group adjacent windows with similar signal into segments.

## Output

Each segment contains:

- `loc.start`, `loc.end` → genomic coordinates  
- `seg.mean` → mean log2-ratio of the segment  
- `approx_ratio = 2^seg.mean` → fold-change vs baseline

## Interpretation
seg.mean ≈ 0 (approx_ratio ≈ 1) → baseline coverage

seg.mean > 0 → increased coverage

seg.mean < 0 → decreased coverage


| Ploidy     | Baseline CN | Gain | Fold change | log2  |
| ---------- | ----------- | ------------ | ----------- | ----- |
| Haploid    | 1           | 2            | 2×          | 1.00  |
| Diploid    | 2           | 3            | 1.5×        | ~0.58 |
| Triploid   | 3           | 4            | 1.33×       | ~0.42 |
| Tetraploid | 4           | 5            | 1.25×       | ~0.32 |

| Ploidy     | Baseline CN | Loss | Fold change | log2   |
| ---------- | ----------- | ------------ | ----------- | ------ |
| Diploid    | 2           | 1            | 0.5×        | -1.00  |
| Triploid   | 3           | 2            | 0.67×       | ~-0.58 |
| Tetraploid | 4           | 3            | 0.75×       | ~-0.42 |

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
    bioconductor-dnacopy \
    -c conda-forge -c bioconda
```
Activate the environment:

```{bash}
mamba activate sppcomp
```

## Example


CBS 2834 a mid coverage 3n S.cer x S. kud x S.uva sample with complex aneuploidies and species combinations.

<img width="1566" height="1056" alt="Screenshot from 2026-04-12 15-25-11" src="https://github.com/user-attachments/assets/ea64af8d-356e-484a-abb1-c51b0a20a3ca" />

Signal segmentation CBS 2834

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-03-43" src="https://github.com/user-attachments/assets/a93392cb-0a3a-48e6-8a4a-7750279375aa" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-04-11" src="https://github.com/user-attachments/assets/55cf7609-b58f-4628-b120-b0b586eb2848" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-04-42" src="https://github.com/user-attachments/assets/3a45497c-8e12-4c18-986c-25af535b4e00" />

<img width="1849" height="885" alt="Screenshot from 2026-04-14 18-05-10" src="https://github.com/user-attachments/assets/3505a3ac-2459-493d-a9c4-6748ea72a73b" />

## Citations

Please, if you use this pipeline, cite this repo.
