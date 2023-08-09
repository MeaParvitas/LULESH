cmake_minimum_required(VERSION 3.10)

project(LULESH CXX)

option(WITH_MPI     "Build LULESH with MPI"          TRUE)
option(WITH_OPENMP  "Build LULESH with OpenMP"       TRUE)
option(WITH_SILO    "Build LULESH with silo support" FALSE)
option(WITH_CALIPER "Build LULESH with Caliper/Adiak support" FALSE)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

set(LULESH_SOURCES
  lulesh-comm.cc
  lulesh-init.cc
  lulesh-util.cc
  lulesh-viz.cc
  lulesh.cc)

if (WITH_CALIPER)
  find_package(caliper REQUIRED)
  find_package(adiak REQUIRED)

  add_definitions("-DUSE_CALIPER")

  execute_process(COMMAND
      whoami
    OUTPUT_VARIABLE
      LULESH_BUILT_BY
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  configure_file(lulesh-build-metadata.cc.in ${CMAKE_CURRENT_BINARY_DIR}/lulesh-build-metadata.cc)

  list(APPEND LULESH_SOURCES
    lulesh-caliper-util.cc
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-build-metadata.cc)
  list(APPEND LULESH_DEPENDENCIES
    caliper
    ${adiak_LIBRARIES})
endif()

if (WITH_MPI)
  find_package(MPI REQUIRED)
  add_definitions("-DUSE_MPI=1")
  list(APPEND LULESH_DEPENDENCIES MPI::MPI_CXX)
else()
  add_definitions("-DUSE_MPI=0")
endif()

if (WITH_OPENMP)
  find_package(OpenMP REQUIRED)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

if (WITH_SILO)
  find_path(SILO_INCLUDE_DIR silo.h
    HINTS ${SILO_DIR}/include)
  find_library(SILO_LIBRARY
    NAMES siloh5
    HINTS ${SILO_DIR}/lib)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(SILO DEFAULT_MSG
    SILO_LIBRARY
    SILO_INCLUDE_DIR)

  if (SILO_FOUND)
    add_definitions("-DVIZ_MESH")
    include_directories(${SILO_INCLUDE_DIR})
    #   Note: silo needs to be built as a dynamic lib, otherwise
    # there are additional dependencies (hdf5) which we don't know.
    # This would be fixed by silo providing a CMake package.
    list(APPEND LULESH_DEPENDENCIES ${SILO_LIBRARY})
  endif()
endif()

set(LULESH_EXEC lulesh2.0)

add_executable(${LULESH_EXEC} ${LULESH_SOURCES})
target_link_libraries(${LULESH_EXEC} PUBLIC ${LULESH_DEPENDENCIES})

install(TARGETS lulesh2.0 DESTINATION ${CMAKE_INSTALL_BINDIR})
