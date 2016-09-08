program hello_world

   use mpi_f08
   use omp_lib

   implicit none

   type(MPI_Comm) :: comm
   integer :: myid, npes, ierror
   integer :: name_length

   integer :: num_threads, my_thread

   character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name

   call MPI_Init(ierror)

   comm = MPI_COMM_WORLD

   call MPI_Comm_Rank(comm,myid,ierror)
   call MPI_Comm_Size(comm,npes,ierror)
   call MPI_Get_Processor_Name(processor_name,name_length,ierror)

   !$omp parallel default(shared) private(num_threads, my_thread)
   num_threads = omp_get_num_threads()
   my_thread   = omp_get_thread_num()

   write (*,'(A,X,I4,X,A,X,I4,X,A,X,I4,X,A,X,I4,X,A,X,A)') &
      "Hello from thread", my_thread, "out of", num_threads, &
      "on process", myid, "of", npes, "on processor", trim(processor_name)

   !$omp end parallel

   call MPI_Finalize(ierror)

end program hello_world
