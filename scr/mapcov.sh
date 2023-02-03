#!/bin/bash

BaseDir=$1
nSamples=$2 # number of samples
nThreads=$3 # per-sample number of threads 

# enter base folder 
cd $BaseDir

# directory with mapping data
mapDir=$BaseDir/map

# directory for TXT Checkpoint (cps)
cpsDir=$BaseDir/cps

# directory with coverage info
covDir=$BaseDir/cov

# add variable is (nThreads - 1)
# note: some commands add threads to the default value (1 thread)
add=$(($nThreads - 1))

# index the concatenated assemblies in rep
bwa index ${BaseDir}/rep/*fa >/dev/null 2>  ${BaseDir}/logs/Time.index.err

for IndS in $(ls -Sr ./seq/*_1.*gz | cut -d"/" -f3 | cut -d"_" -f1)
do
  # take the sample name.
  # check if it is already stored in cps/cps.txt
  cps=$(grep -w $IndS $BaseDir/cps/cps.txt)
  
  # if $cps is empty the sample will be processed, skipped otherwise. 
  if [ -z "$cps" ]
  then
  
  # i increases progressively and will never be higher than the number specified in $nSamples
  ((i++))
  (
    # check for the presence of paired files 
    revers=$(ls ./seq/$IndS"_2."*"gz")
    
    # path to the assembly
    IndR=$(ls ${BaseDir}"/rep/"*.fa)
    
    # ID assembly
    refID=$(basename $IndR | cut -d "." -f 1)
    
    # run BWA according to the fact the reads are either single or paired end 
    if [ ! -z "$revers" ]
    then

      bwa mem -t $nThreads $BaseDir/rep/$refID.fa $BaseDir/seq/$IndS"_1"*".gz" $BaseDir/seq/$IndS"_2"*".gz" -o $mapDir/$IndS".sam" 2> /dev/null
      
    else
      
      bwa mem -t $nThreads $BaseDir/rep/$refID.fa $BaseDir/seq/$IndS"_1"*".gz" -o $mapDir/$IndS".sam" 2> /dev/null
      
    fi
    # samtools workflow as suggested in the documentation (http://www.htslib.org/workflow/fastq.html)
    samtools fixmate -@$add -O bam,level=1 -m $mapDir/$IndS".sam" $mapDir/$IndS".fix.bam"
      
    samtools sort -l 1 -@$nThreads $mapDir/$IndS".fix.bam" -T $BaseDir/tmp/$IndS".tmp.bam" -o $mapDir/$IndS".fix.srt.bam"	 
    
    samtools markdup -@$add -O bam,level=1 $mapDir/$IndS".fix.srt.bam" $mapDir/$IndS".fix.srt.mrk.bam"	 
      
    samtools view -@$add $mapDir/$IndS".fix.srt.mrk.bam" -o $mapDir/$IndS.$refID.bam
      
    samtools index $mapDir/$IndS.$refID.bam
      
    # comment the line below if you want to keep intermediate files 
    rm -r $mapDir/$IndS.sam  $mapDir/$IndS.fix.bam $mapDir/$IndS.fix.srt.bam $mapDir/$IndS.fix.srt.mrk.bam
    
    # At the time of writing, samtools coverage does not accept BED file as input.
    # The while loop below is a turn around.
    while read -r line
    do
      
    chr=$(echo $line | cut -d" " -f1)
    start=$(echo $line | cut -d" " -f2)
    end=$(echo $line | cut -d" " -f3)
    # measure coverage statistics across windows. Only reads with MQ >= 5 and BQ >= 20 are included.
    # unmapped, secondary, QC failed and duplicated reads are excluded.
    samtools coverage -q5 -Q20 --ff UNMAP,SECONDARY,QCFAIL,DUP -r $chr:$start-$end $mapDir/$IndS.$refID.bam | grep -v "#" >> $BaseDir/cov/$IndS".binned.cov"
      
    done < $BaseDir"/rep/"*".bed"
      
    wait
    # add a column to binned.cov with the strain name
    gawk -i inplace -v var="$IndS" -F'\t' 'BEGIN{OFS=FS}{print $0 OFS var}' $BaseDir/cov/$IndS".binned.cov"
    
    # append strain name to ./cps/cps.txt
    echo $IndS >> $BaseDir/cps/cps.txt
    
    ### uncomment the line below if you want to remove the BAMs and indeces
    ### rm $mapDir/$IndS.$refID.bam $mapDir/$IndS.$refID.bam.bai
    
    )&
    
    # The terminal part of the code hosts a job controller that allows the efficient use of the threads required. 
    # This is obtained by an if statement that permits the for loop to proceed to the next sample as soon as the number of running samples moves down, below the upper limit imposed by the variable $nSamples.
    if (( i % nSamples == 0 )); then
    wait -n
    i=$(($nSamples-1))
    fi
  fi
done
