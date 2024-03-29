program hello_world

   use iso_fortran_env
   use mpi

   implicit none

   integer :: comm
   integer :: myid, npes, ierror
   integer :: name_length

   character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name

   integer :: version, subversion, resultlen
   character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: version_string

   call mpi_get_version(version, subversion, ierror)

   call mpi_get_library_version(version_string, resultlen, ierror)

   call mpi_init(ierror)

   comm = MPI_COMM_WORLD

   call MPI_Comm_Rank(comm,myid,ierror)
   call MPI_Comm_Size(comm,npes,ierror)
   call MPI_Get_Processor_Name(processor_name,name_length,ierror)

   if (myid == 0) then
      write (output_unit,'("Compiler Version:",1X,A)') trim(compiler_version())
      write (output_unit,'("MPI Version:",1X,I1,".",I1)') version, subversion
      write (output_unit,'("MPI Library Version:",1X,A)') trim(version_string)
   end if

   call mpi_barrier(MPI_COMM_WORLD, ierror)

   write (output_unit,'(A,1X,I4,1X,A,1X,I4,1X,A,1X,A)') "Process", myid, "of", npes, "is on", trim(processor_name)

   call MPI_Finalize(ierror)

end program hello_world
