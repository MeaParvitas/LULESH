#!/bin/sh

# This script builds Lulesh binaries for evaluating the Caliper 
# instrumentation overhead.

#   Use the Spack package manager to build the Caliper and Adiak libraries:
# https://github.com/spack/spack
spack install caliper@2.3.0 +adiak +mpi

# Use spack to build an unmodified Lulesh binary for comparison
spack install lulesh@2.0.3 +mpi

MPI_DIR=$(spack location --install-dir mpi)
CALIPER_DIR=$(spack location --install-dir caliper)
ADIAK_DIR=$(spack location --install-dir adiak)

# Build instrumented Lulesh
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release \
    -DWITH_MPI=On \
    -DMPI_C_COMPILER=${MPI_DIR}/bin/mpicc \
    -DMPI_CXX_COMPILER=${MPI_DIR}/bin/mpicxx \
    -Dcaliper_DIR=${CALIPER_DIR}/share/cmake/caliper \
    -Dadiak_DIR=${ADIAK_DIR}/lib/cmake/adiak ..
make -j
