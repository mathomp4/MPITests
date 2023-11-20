cmake_minimum_required(VERSION 3.17)

project(MPI_Fortran_Hello)
enable_language(Fortran)

find_package(MPI REQUIRED)

message(STATUS "Run: ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} ${MPIEXEC_PREFLAGS} EXECUTABLE ${MPIEXEC_POSTFLAGS} ARGS")

add_executable(helloWorld.mpi3.exe helloWorld.mpi3.F90)
target_link_libraries(helloWorld.mpi3.exe MPI::MPI_Fortran)
