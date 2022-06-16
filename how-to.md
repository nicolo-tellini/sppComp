The setup of the run requires you change the paremeters in the <code>runner.sh</code> with your favorite text editor.

### runner.sh

The only section you want to interact with is  

```sh

#####################
### user settings ###
#####################

# STEP1: The pipeline runs the short-read alignment against the reference genome,

shortReadMapping="yes" # change with "no" if you want to skip STEP1
# How many samples do you want to align at the same time?
nSamplesBWA=2 
# How many threads do you want to use, for each sample?
nThreads=2 

# NOTE: if you run 2 samples with 2 threads you are going to use 4 (2x2) threads

# STEP2: The pipeline creates a bed file with non-overlapping consecutive windows,

binning="yes" # change with "no" if you want to skip STEP2
#  what is the size of the windows(in bp)?
wSize=10000 

# STEP3 : The pipeline extracts the coverage across the windows,

statsBins="yes" # change with "no" if you want to skip STEP3
# The coverage can be extracted in parallel n-windows by n-windows.
nWindow=1 
# How many samples do you want to process at the same time?
nSamplesSAM=2 

# NOTE: nSamplesSAM affects the use of threads. 
# The command runs single thread, so nSamplesSAM=2 uses 2 threads.

# STEP4: The pipeline generates the plot 
# with the average covarege across the chromosomes 
# for different Saccharomyces species

plotspecies="yes" # change with "no" if you want to skip STEP4
# do you want to print the plots on a "single" pdf or in "multi" pdf files (one per sample)
pdf="single" # "single" or "multi"

#####################
### settings' end ###
#####################

```

The line above show the default parameters. 

### I modified the runner.sh and now?

You can move the fastqs files inside *seq* and execute the pipeline. 

I suggest the following command:

```sh
nohup bash runner.sh &
```

A number will be printed on the terminal. For example:

```sh
[7] 81589
```
The number outside the squared brackets is the process ID of the command you run. 

You may to save it on a txt file. In case you mistakenly run the pipeline with the incorrect parameters,

the command: 

```sh
kill -9 $yourPID
```

will stop the pipeline.


nohup generates a log file, called <code>nohup.out</code>, which collects the steps and the information concerning the current status of the pipeline as well errors. It is a *txt* file and can be easily accessed with <code>cat</code>.

An example of <code>nohup.out</code> :

```sh
Preparing the assemblies...
short-read mapping ...
BWA mapping ... OK
binning assemblies ...
binner ... OK
getting coverage stats ...
coverage stats... OK
plotting species components ...
species plot... OK
```

Here an example of the plot of the strain CBS 2834 that is stored inside *plots* dir. at the end of the pipeline:

<p align="center">
  <img src="https://github.com/nicolo-tellini/sppComb/blob/main/CBS2834_profile.png" alt="sppComb flow"/>
</p>
