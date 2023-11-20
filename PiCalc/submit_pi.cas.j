#!/bin/bash -f

#SBATCH --ntasks=120
#SBATCH --constraint=cas
#SBATCH --time=0:10:00
#SBATCH --account=g0620
#SBATCH --partition=preops
#SBATCH --qos=benchmark
#SBATCH --job-name=picalc
#SBATCH --chdir=/home/mathomp4/MPITests/PiCalc

ulimit -s unlimited

module load comp/gcc/10.3.0 comp/intel/2021.6.0 mpi/impi/2021.6.0
module list

mpirun -np 120 ./pi3f90.exe

