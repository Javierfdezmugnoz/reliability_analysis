# Reliability Analysis Experiment
1. Compile darknet in the gpu node: ``sbatch -A gpu -p gpu -q small_gpu --gres=gpu:1 compile_darknet.sh`` 2. Run experiments: ``sbatch --array=0-999 -A gpu -p gpu -q small_gpu 
--gres=gpu:1 reliability_analysis.sh <launch_iteration>``
# Modifications before running compile_darknet.sh
1. Download YOLO: git clone 2. The last version that let me compile without problems is ``bef28445e57cd560fa3d0a24af98a562d289135b``. To come back: ``git checkout -f bef2844`` 
3. Modify Makefile (choose the proper cuda compiler and uncomment the compute capability of the gpu architecture. sm_75 in our case) 4. Replace ``src/detector.c``, 
``src/image.c`` and ``src/image.h`` 5. Include folder ``bdd100k_images_10k`` and include the set de images chosen 6. Include ``data/file_lists.txt`` including the names of the 
previously mentioned images 7. Download the activation weights: ``wget https://pjreddie.com/media/files/yolov3-tiny.weights`` 8. Include the bit inversor program and the 
executable: ``bitflip.cpp`` and ``bitflip`` 9. Include the .sh files: ``fi_CNN.sh`` and ``compile_darknet.sh`` sbatch --array=0-2 -A gpu -p gpu -q small_gpu --gres=gpu:1 
reliability_analysis.sh 0
# Before launching the fi_experiments
1. Create a ``<root_path>/outputs`` folder and inside it to create as much folders as images have been selected ``image_<number>`` 2. Include at the end of the file ``rm -rf 
/scratch/1/jfernand/results/`` to delete all the content in this folder, change `array_iterations` from 1000 to 1 and launch ``sbatch --array=0 -A gpu -p gpu -q small_gpu 
--gres=gpu:1 reliability_analysis.sh 0`` If you have stop a job launched in slurm, it would be recommended to repeat this step. Reason: Imagine that the experiment launch a 
fault injection in bit 1020 (random value) and a a ``1020.csv`` file with the results has just been created. Then the values are stored at the end of the file and can produce 
problems in the evaluation.
3. Perform the experiment: ``sbatch --array=0-999 -A gpu -p gpu -q  small_gpu --gres=gpu:1 reliability_analysis.sh <launch_value>``. As ``--array`` only accept upto 999, several launches are necessary.
