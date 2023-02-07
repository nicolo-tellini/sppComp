#!/bin/bash

binsize=10000 # windows size
nSamples=2 # number of sample to run in parallel (mapping and coverage extraction)
nThreads=2 # per-sample number of threads

# Default: 4 samples single thread (4 threads per time) 

if [[ ! -d logs ]]; then mkdir logs; fi

BaseDir=$(pwd)

# check logs folder
if [[ ! -d ${BaseDir}/logs ]]; then mkdir ${BaseDir}/logs; fi

# enter base folder 
cd ${BaseDir}

# directory with mapping data
mapDir=${BaseDir}/map

if [[ ! -d ${mapDir} ]]; then
mkdir ${mapDir}
fi

# directory for TXT Checkpoint (cps)
cpsDir=${BaseDir}/cps
if [[ ! -d ${cpsDir} ]]; then
mkdir ${cpsDir}
fi

# TXT Checkpoint
FILE=${BaseDir}/cps/cps.txt
if test -f ${FILE}; then
echo "${FILE} exists"
else
touch ${FILE}
echo "${FILE} created."
fi

# directory with coverage info
covDir=${BaseDir}/cov
if [[ ! -d ${covDir} ]]; then
mkdir ${covDir}
fi

# binner 
/usr/bin/time -v Rscript ${BaseDir}/scr/binner.r ${BaseDir} ${binsize} > ${BaseDir}/logs/binner.out 2> ${BaseDir}/logs/Time.binner.err

# mapping and coverage
# NOTE : the per-window average coverage is computed by samtools coverage with the following options: -q5 -Q20 --ff UNMAP,SECONDARY,QCFAIL,DUP
# feel free to change them if these do not fit your data. You can find the command in the script ./scr/mapcov.sh at line 83.
/usr/bin/time -v bash ${BaseDir}/scr/mapcov.sh ${BaseDir} ${nSamples} ${nThreads}  > ${BaseDir}/logs/mapcov.out 2> ${BaseDir}/logs/Time.mapcov.err

wait

# plotter 
/usr/bin/time -v Rscript ${BaseDir}/scr/plot.r ${BaseDir} ${binsize} > ${BaseDir}/logs/plot.out 2> ${BaseDir}/logs/Time.plot.err
