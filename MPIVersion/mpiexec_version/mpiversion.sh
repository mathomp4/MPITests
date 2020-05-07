#!/bin/bash

shopt -s extglob

if command -v mpirun_rsh >& /dev/null
then
   MPI_CMD="mpirun_rsh -v"
else
   MPI_CMD="mpiexec --version"
fi

if ! $MPI_CMD >& /dev/null
then
   echo "Trying ${MPI_CMD}..."
   echo "You don't seem to have an MPI stack installed"
   exit 1
fi

MPI_STRING=$(${MPI_CMD} 2>&1 | head -n1)

case $MPI_STRING in
   *MPT*)
      MPI_STACK="MPT"
      ;;
   *mvapich2*)
      MPI_STACK="MVAPICH2"
      ;;
   *Intel*)
      MPI_STACK="Intel MPI"
      ;;
   *Open*)
      MPI_STACK="Open MPI"
      ;;
   *HYDRA*)
      MPI_STACK="MPICH3"
      ;;
   *)
      MPI_STACK="UNKNOWN"
      exit 2
      ;;
esac

echo $MPI_STACK

exit 0
