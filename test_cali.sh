#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=00:10:00
#SBATCH --output=output.out
#SBATCH --error=error.er
#SBATCH --mail-type=END
#SBATCH --mail-user=ritter5@llnl.gov
#SBATCH --exclusive
#SBATCH --ntasks 8
#SBATCH -J lulesh

ml gcc

CALI_LOG_VERBOSITY=1 CALI_CONFIG=spot,time.exclusive,profile.mpi srun ./build/lulesh2.0 -s 30