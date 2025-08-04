program main
   use mpi_f08

   implicit none
   integer :: ierror, provided

   call MPI_Init_thread(MPI_THREAD_MULTIPLE, provided, ierror)
   if (provided  < MPI_THREAD_MULTIPLE) THEN
      print *, "We do not support MPI_THREAD_MULTIPLE"
      call MPI_Abort(MPI_COMM_WORLD, -1, ierror)
   else
      print *, "We support MPI_THREAD_MULTIPLE"
   end if
   call MPI_Finalize(ierror)
end program main
