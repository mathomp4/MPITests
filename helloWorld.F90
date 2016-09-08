program hello_world

   use mpi

   implicit none

   integer :: comm
   integer :: myid, npes, ierror
   integer :: name_length

   character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name

   call mpi_init(ierror)

   comm = MPI_COMM_WORLD

   call MPI_Comm_Rank(comm,myid,ierror)
   call MPI_Comm_Size(comm,npes,ierror)
   call MPI_Get_Processor_Name(processor_name,name_length,ierror)

   write (*,'(A,X,I4,X,A,X,I4,X,A,X,A)') "Process", myid, "of", npes, "is on", trim(processor_name)

   call MPI_Finalize(ierror)

end program hello_world
