# Alignment
sppComb implements state-of-art tools for boosting the performances as well as an efficient use of the threads.

[bwa-mem2](https://github.com/bwa-mem2/bwa-mem2) is the new implementation of bwa algorithm, by mean diverse low level optimizations "*resulting in up to 3.5x and 2.4x speedups on end-to-end compute time over the original BWA-MEM on single thread and single socket of Intel Xeon Skylake processor*" <sup>[1](https://ieeexplore.ieee.org/document/8820962)</sup>.

[samtools](https://github.com/samtools/samtools) versions 1.14 comes along with an improved <code>sort</code> command in the use of temporary files "*both tidying up if it fails and recovery when facing pre-existing temporary files*" <sup>[2](https://github.com/samtools/samtools/releases/tag/1.14)</sup>. This allows the piping (<code>|</code>) of most of the <code>samtools</code> commands that generate the <code>bam</code> file (<code>fixmate</code>,<code>sort</code>,<code>markdup</code>).

The code is embedded inside a bash for loop that controls the number of samples to process in parallel. The terminal part of the code hosts a job controller that allows the **efficient** use of the threads required. This is obtained by an if statment that permits the for loop to proceed to the next sample as soon as the number of required threads moves down, below the upper limit imposed by the parameters specified in the <code>runner.sh</code>.

```sh
if (( i % nSamplesBWA == 0 )); then
wait -n
i=$(($nSamplesBWA-1))
fi
```
where <code>i</code> hosts the number of samples currently running and <code>nSamplesBWA</code> the max number of samples the script processes in parallel.

# Genome binning 

The fasta genome is binnded in R by vectorialized functions from <code>GenomicRanges</code> library. 
<code>fwrite</code> from <code>data.table</code> replaces the <code>write.table</code> speeding up the step resulting in an enanchement of up to 40x <sup>[3](https://stackoverflow.com/questions/10505605/speeding-up-the-performance-of-write-table),[4](https://predictivehacks.com/the-fastest-way-to-read-and-write-file-in-r/)</sup>.

# Coverage extraction 

The data about the coverage are recovered with <code>samtools coverage</code>, introduced in version 1.10. Compared to <code>samtools depth</code>, <code>samtools coverage</code> computes statitcs on the depth at each specified region and returns the results on a tabulated text. Altought at the time I am writing this lines, <code>samtools coverage</code> does not support <code>bed</code> files nor custom outputs these improvements have been suggested and taken in consideration by samtools' guys ([1662](https://github.com/samtools/samtools/issues/1662)). As soon as available, they will be implementend in the pipeline, overcoming the necessity to run the command for each single region. 

# Plotting

The plots are generated in R with <code>ggplot2</code>. The script makes large use of functional programming as well as base commands to prepare the <code>data.frame</code> and plotting. All the <code>data.frame</code> are preprocessed by <code>fread</code> before the allocation and, subsequently, stored in a single list. This allows for a one-shot solution that reduces dramatically the run time, but it comes with an higher consume of RAM memory. For example, processing CBS 2834 required around 12 MB, while processing 50 copies of the same sample 0.2GB (200 MB).

# References

[1](https://ieeexplore.ieee.org/document/8820962) Vasimuddin, Md, et al. "Efficient architecture-aware acceleration of BWA-MEM for multicore systems." 2019 IEEE International Parallel and Distributed Processing Symposium (IPDPS). IEEE, 2019.<br />
[2](https://github.com/samtools/samtools/releases/tag/1.14) samtools v 1.14<br />
[3](https://stackoverflow.com/questions/10505605/speeding-up-the-performance-of-write-table) Stack Overflow<br />
[4](https://predictivehacks.com/the-fastest-way-to-read-and-write-file-in-r/) Predictive Hacks by Billy & George<br />
