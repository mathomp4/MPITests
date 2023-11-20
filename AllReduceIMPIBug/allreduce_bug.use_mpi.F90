program test_allreduce
use mpi
implicit none

integer :: status, rank

call MPI_Init(ierror=status)
call MPI_COMM_RANK(MPI_COMM_WORLD,rank,ierror=status)
call MPI_ALLReduce(MPI_IN_PLACE,rank,1,MPI_INTEGER,MPI_MAX,MPI_COMM_WORLD,ierror=status)
call MPI_Finalize(ierror=status)

end program
