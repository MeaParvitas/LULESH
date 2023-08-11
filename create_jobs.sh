#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=02:00:00
#SBATCH --output=%J.out
#SBATCH --error=%J.err
#SBATCH --mail-type=END
#SBATCH --mail-user=mckinsey1@llnl.gov
#SBATCH --exclusive

set -e

base_dir="/usr/workspace/thicket/rajaperf-july-2023/quartz/gcc10.3.1_"

problem_size=$1
OP=$2
trial=$3
dir="${base_dir}${problem_size}/${OP}/${trial}"

mkdir -p $dir

CALI_CONFIG="output.format=cali" \
   srun  ../../bin/gcc10.3.1_${OP}.exe \
   --variants Base_OpenMP Base_Seq RAJA_OpenMP RAJA_Seq \
   --size ${problem_size} \
   --outdir $dir \
   -sp

/usr/workspace/thicket/setdirperms.sh ${base_dir}${problem_size}/${OP}/${trial}