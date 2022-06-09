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
# rm -rf /scratch/1/jfernand/results/
echo "==================================================="
echo "$PWD"
echo "==================================================="

# 1st time you have to include the following section:
# rsync -r ${INSPATH}/* .
# make  

# Create a process identifier
launch_iteration=${1}
Iterations_launch=1000
array_iterations=1000
init_fi_idx=$((launch_iteration*Iterations_launch*array_iterations))
SLURM_ARRAY_AUX=$((SLURM_ARRAY_TASK_ID*Iterations_launch+init_fi_idx))
echo "==================================================="
echo "launch_iteration:$launch_iteration"
echo "Iterations_launch: $Iterations_launch"
echo "init_fi_idx:$init_fi_idx"
echo "SLURM_ARRAY_AUX:$SLURM_ARRAY_AUX"
echo "SLURM_ARRAY_TASK_ID:$SLURM_ARRAY_TASK_ID"
echo "==================================================="

# Create the folder structure:
mkdir results
mkdir data
mkdir cfg


echo "==================================================="
echo "      FOLDER CONTENT"
echo "==================================================="
# Syncronize the required content
rsync -r $INSPATH/bdd100k_images_10k .
rsync $INSPATH/bitflip.cpp .
rsync $INSPATH/cfg/coco.data cfg/.
rsync $INSPATH/data/coco.names data/.
rsync -r $INSPATH/data/labels data/.
rsync $INSPATH/darknet .
rsync $INSPATH/data/file_list.txt data/.
rsync $INSPATH/cfg/yolov3-tiny.cfg cfg/.
rsync $INSPATH/yolov3-tiny.weights .


# Compile the bitflip inversion
echo "$PWD"
#srun g++ bitflip.cpp -o bitflip
#srun bitflip /scratch/1/jfernand/yolov3-tiny.weights $SLURM_ARRAY_AUX 30 /scratch/1/jfernand/results/${SLURM_ARRAY_AUX}/yolov3-tiny_fi.weights
#srun darknet detector test cfg/coco.data cfg/yolov3-tiny.cfg results/${SLURM_ARRAY_AUX}/yolov3-tiny_fi.weights -slurm_index ${SLURM_ARRAY_AUX} -dont_show -ext_output <data/file_list.txt> results/${SLURM_ARRAY_AUX}/results.csv 
echo "=================================================================================="


BIT_FLIP=30
MAX_ITERATIONS=$((SLURM_ARRAY_AUX+array_iterations-1))
echo "MAX_ITERATIONS=$MAX_ITERATIONS"


for idx_weight in `seq $SLURM_ARRAY_AUX 1 $MAX_ITERATIONS`
do
    mkdir /scratch/1/jfernand/results/${idx_weight}
    srun bitflip /scratch/1/jfernand/yolov3-tiny.weights $idx_weight 30 /scratch/1/jfernand/results/${idx_weight}/yolov3-tiny_fi.weights
    srun darknet detector test cfg/coco.data cfg/yolov3-tiny.cfg results/${idx_weight}/yolov3-tiny_fi.weights -slurm_index ${idx_weight} -dont_show -ext_output <data/file_list.txt> results/${idx_weight}/results_${idx_weight}.csv
    # Copy the results in the proper folder
    # rsync /scratch/1/jfernand/results/${idx_weight}/results_* ${OUTSPATH}/image_0/${idx_weight}_results.csv
    rsync /scratch/1/jfernand/results/${idx_weight}/0_* ${OUTSPATH}/image_0/${idx_weight}.csv
    rsync /scratch/1/jfernand/results/${idx_weight}/1_* ${OUTSPATH}/image_1/${idx_weight}.csv
    rsync /scratch/1/jfernand/results/${idx_weight}/2_* ${OUTSPATH}/image_2/${idx_weight}.csv
    rsync /scratch/1/jfernand/results/${idx_weight}/3_* ${OUTSPATH}/image_3/${idx_weight}.csv
    rsync /scratch/1/jfernand/results/${idx_weight}/4_* ${OUTSPATH}/image_4/${idx_weight}.csv
    # rsync /scratch/1/jfernand/results/${idx_weight}/5_* ${OUTSPATH}/image_5/${idx_weight}.csv
    # rsync /scratch/1/jfernand/results/${idx_weight}/6_* ${OUTSPATH}/image_6/${idx_weight}.csv
    # rsync /scratch/1/jfernand/results/${idx_weight}/7_* ${OUTSPATH}/image_7/${idx_weight}.csv
    # rsync /scratch/1/jfernand/results/${idx_weight}/8_* ${OUTSPATH}/image_8/${idx_weight}.csv
    # rsync /scratch/1/jfernand/results/${idx_weight}/9_* ${OUTSPATH}/image_9/${idx_weight}.csv
    rm -rf /scratch/1/jfernand/results/${idx_weight}
done




#rm results/*

echo "==================================================="
echo "      DONE "
echo "==================================================="


