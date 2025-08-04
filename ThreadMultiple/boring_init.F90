program main
   use mpi

   implicit none
   integer :: ierror

   call MPI_Init(ierror)
   call MPI_Finalize(ierror)
end program main
