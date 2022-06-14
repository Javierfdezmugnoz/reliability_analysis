#!/bin/bash
# Create a process identifier
launch_iteration=${1}
Iterations_launch=1000000
init_fi_idx=$((launch_iteration*Iterations_launch))

BIT_FLIP=30
MAX_ITERATIONS=$((init_fi_idx+Iterations_launch-1))
echo "${init_fi_idx} and ${MAX_ITERATIONS}"

for idx_weight in `seq $init_fi_idx 1 $MAX_ITERATIONS`
do
    mkdir results/${idx_weight}
    ./bitflip yolov3-tiny.weights $idx_weight 30 yolov3-tiny_fi.weights
    ./darknet detector test cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny_fi.weights -slurm_index ${idx_weight} -dont_show -ext_output <data/file_list.txt> results/${idx_weight}/results_${idx_weight}.csv
done
