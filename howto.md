# HOW-TO

The setup of the run requires you change the paremeters in the <code>runner.sh</code> with your favorite text editor.

### :walking: runner.sh 

The only section you have to interact with is  

```sh

#####################
### user settings ###
#####################

# STEP1: The pipeline runs the short-read alignment against the reference genome,

shortReadMapping="yes" # change with "no" if you want to skip STEP1
# How many samples do you want to align at the same time?
nSamplesBWA=1 
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

The default parameters are not greedy and allow a smooth run also in a laptop with a few resources.


### :runner: run

I suggest the following command:

```sh
nohup bash runner.sh &
```
A number will be printed on the terminal. For example:
```sh
[7] 81589
```
The number outside the squared brackets is the process ID of the command you run. You may want to conserve it. In case you mistakenly run the pipeline with the incorrect parameter you can kill it. <code>nohup</code> generates a log file, called <code>nohup.out</code>, which collects the steps and the information concerning the **current status** of the pipeline as well **errors**. It is a txt file and can be accessed with <code>cat</code>.

An example of <code>nohup.out</code> :

```sh
Thu Jun 16 18:43:35 CEST 2022
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
If the pipeline ends without errors, the results are stored inside the *plots* directory. 

### :v: GG!

If there are errors you do not how to fix reach out to me here :point_right: nicolo.tellini.2@gmail.com
