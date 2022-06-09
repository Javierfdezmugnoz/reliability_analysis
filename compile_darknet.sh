#!/bin/bash
# Define the paths where are stored the output/errors/Addresses: Definition of the environment
NAME=${2}
JOBNAME="$(date +%m_%d_%H_%M_%S)"
OUTSPATH="/scratch/nas/3/jfernand/reliability_analysis/outputs"
ERRSPATH="/scratch/nas/3/jfernand/reliability_analysis/errors/error_$JOBNAME.out"
INSPATH="/scratch/nas/3/jfernand/reliability_analysis"

# Create the folder where it will be stored the results

# Creation of the local folder where is stored the data
cd /scratch/1/jfernand/
echo "==================================================="
echo "$PWD"
echo "==================================================="
rm -rf *


# 1st time you have to include the following section:
rsync -r ${INSPATH}/* .
make 

echo "==================================================="
echo "      FOLDER CONTENT"
echo "==================================================="
ls -l 

# Copy the results in the proper folder
rsync darknet ${INSPATH}/.

#rm results/*

echo "==================================================="
echo "      DONE "
echo "==================================================="



