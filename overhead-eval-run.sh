#!/bin/sh

#   This script runs instrumentation overhead evaluation experiments.
# Runs each profiling configuration 5 times. For results, extract the
# built-in timing output reported by Lulesh, then compute min/max/avg
# from the output (left as exercise for the reader):
#
# $ ./overhead-eval-run.sh | tee output.txt
# $ grep -e "\*\*" -e "Grind time" output.txt
#
# All configurations use the default Lulesh input problem.

export OMP_NUM_THREADS=4

PREFIX="mpirun -np 8"

LULESH_INST=$(pwd)/build/lulesh2.0
LULESH_UNINST=$(spack location --install-dir lulesh)/bin/lulesh2.0

# Uninstrumented run for comparison

echo "******** uninst"

for run in 1 2 3 4 5
do
    ${PREFIX} ${LULESH_UNINST}
done

# Instrumented run, no active profiling configuration

echo "******** noconfig"

for run in 1 2 3 4 5
do
    ${PREFIX} ${LULESH_INST}
done

# Instrumented run, basic region profiling

echo "******** spot"

for run in 1 2 3 4 5
do
    ${PREFIX} ${LULESH_INST} -P spot
done

# Instrumented run, region + MPI profiling

echo "******** spot.mpi"

for run in 1 2 3 4 5
do
    ${PREFIX} ${LULESH_INST} -P spot,profile.mpi=true
done
