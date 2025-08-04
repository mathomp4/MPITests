program main
   use mpi

   implicit none
   integer :: ierror, provided

   call MPI_Init_thread(MPI_THREAD_SINGLE, provided, ierror)
   if (provided  < MPI_THREAD_SINGLE) THEN
      print *, "We do not support MPI_THREAD_SINGLE"
      call MPI_Abort(MPI_COMM_WORLD, -1, ierror)
   else
      print *, "We support MPI_THREAD_SINGLE"
   end if
   call MPI_Finalize(ierror)
end program main
