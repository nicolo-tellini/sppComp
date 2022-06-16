The setup of the run requires you change the paremeters in the <code>runner.sh</code> with your favorite text editor.

### runner.sh

The only section you want to interact with is  

```sh

#####################
### user settings ###
#####################

# STEP1
shortReadMapping="yes"
nThreads=2
nSamplesBWA=2

# STEP2
binning="yes"
wSize=10000

# STEP3
statsBins="yes"
nWindow=1
nSamplesSAM=2

# STEP4
plotspecies="yes"
pdf="single" # single or multi

#####################
### settings' end ###
#####################

```
