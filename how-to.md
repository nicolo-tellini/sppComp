The setup of the run requires you change the paremeters in the <code>runner.sh</code> with your favorite text editor.

### runner.sh

The only section you want to interact with is  

```sh

#####################
### user settings ###
#####################

# STEP1: The pipeline runs the short-read alignment against the reference genome,

shortReadMapping="yes" # change with "no" if you want to skip STEP1
nSamplesBWA=2 # How many samples do you want to align at the same time?
nThreads=2 # How many threads do you want to use, for each sample?

# NOTE: if you run 2 samples with 2 threads you are going to use 4 (2x2) threads

# STEP2: The pipeline creates a bed file with non-overlapping consecutive windows,

binning="yes" # change with "no" if you want to skip STEP2
wSize=10000 #  what is the size of the windows(in bp)?

# STEP3 : The pipeline extracts the coverage across the windows,

statsBins="yes" # change with "no" if you want to skip STEP3
nWindow=1 # The coverage can be extracted in parallel n-windows by n-windows.
nSamplesSAM=2 # How many samples do you want to process at the same time?

# NOTE: from testing I noticed that running with nWindow=1 or nWindow=10 does not change significantly the time.
# NOTE2: nSamplesSAM affects the use of threads. The command runs single thread, so nSamplesSAM=2 uses 2 threads.  

# STEP4: The pipeline generates the plot with the average covarege across the chromosomes for different Saccharomyces species

plotspecies="yes" # change with "no" if you want to skip STEP4
pdf="single" # "single" or "multi", do you want to print the plots on a "single" pdf or in "multi" pdf files (one per sample)

#####################
### settings' end ###
#####################

```

The line above show the default paramenters. 
