# build script for LULESH with caliper support

ml gcc cmake   

rm -rf build/
mkdir build/
cd build/
cmake -DCMAKE_BUILD_TYPE=Release -DMPI_CXX_COMPILER=`which mpicxx` -DWITH_CALIPER=On -DCMAKE_PREFIX_PATH=/usr/workspace/asde/caliper-quartz/ -DCMAKE_CXX_COMPILER=`which g++` ..
make

echo "installation completed"
