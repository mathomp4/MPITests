program hello_world

   ! Use necessary modules
   use iso_fortran_env
   use mpi

   implicit none

   ! Declare variables
   integer :: comm
   integer :: myid, npes, ierror
   integer :: name_length

   character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name

   integer :: version, subversion, resultlen
   character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: version_string

   ! Get MPI version information
   call mpi_get_version(version, subversion, ierror)

   ! Get MPI library version string
   call mpi_get_library_version(version_string, resultlen, ierror)

   ! Initialize MPI environment
   call mpi_init(ierror)

   ! Set the communicator to MPI_COMM_WORLD
   comm = MPI_COMM_WORLD

   ! Get rank of the process, size of the communicator, and processor name
   call MPI_Comm_Rank(comm,myid,ierror)
   call MPI_Comm_Size(comm,npes,ierror)
   call MPI_Get_Processor_Name(processor_name,name_length,ierror)

   ! Process 0 prints version information
   if (myid == 0) then
      write (output_unit,'("Compiler Version:",1X,A)') trim(compiler_version())
      write (output_unit,'("MPI Version:",1X,I1,".",I1)') version, subversion
      write (output_unit,'("MPI Library Version:",1X,A)') trim(version_string)
   end if

   ! Synchronize all processes
   call mpi_barrier(MPI_COMM_WORLD, ierror)

   ! Each process prints its rank, total number of processes, and processor name
   write (output_unit,'(A,1X,I4,1X,A,1X,I4,1X,A,1X,A)') "Process", myid, "of", npes, "is on", trim(processor_name)

   ! Finalize MPI environment
   call MPI_Finalize(ierror)

end program hello_world
