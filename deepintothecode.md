# The alignment
sppComb implements state-of-art tools for boosting the perfomances as well as an efficient use of the threads.
bwa-mem2 is the new implementation of bwa algorithm, by mean diverse low level optimization "resulting in up to up to 3.5x and 2.4x speedups on end-to-end compute time over the original BWA-MEM on single thread and single socket of Intel Xeon Skylake processor" [1](https://ieeexplore.ieee.org/document/8820962).

samtools versions 1.14 comes along with an improved <code>sort</code> command in the use of temporary files "both tidying up if it fails and recovery when facing pre-existing temporary files" [2](https://github.com/samtools/samtools/releases/tag/1.14). This allows the piping (<code>|</code>) of most of the <code>samtools</code> commands that generate the <code>bam</code> file (<code>fixmate</code>,<code>sort</code>,<code>markdup</code>).

https://github.com/bwa-mem2/bwa-mem2

# Efficient use of the threads


[1](https://ieeexplore.ieee.org/document/8820962) Vasimuddin, Md, et al. "Efficient architecture-aware acceleration of BWA-MEM for multicore systems." 2019 IEEE International Parallel and Distributed Processing Symposium (IPDPS). IEEE, 2019.
[2](https://github.com/samtools/samtools/releases/tag/1.14) samtools v 1.14
