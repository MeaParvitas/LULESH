#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=00:10:00
#SBATCH --output=output.out
#SBATCH --error=error.err
#SBATCH --mail-type=END
#SBATCH --mail-user=ritter5@llnl.gov
#SBATCH --exclusive
#SBATCH --ntasks 8

ml gcc

srun ./build/lulesh2.0 -s 10 -p -P runtime-report


