program main
   USE mpi

   implicit none

   integer :: ierror
   integer :: provided

   integer, parameter :: required_level = MPI_THREAD_SERIALIZED
   !integer, parameter :: required_level = MPI_THREAD_MULTIPLE

   character(len=:), allocatable :: required_level_string


   select case (required_level)
   case (MPI_THREAD_SINGLE)
      required_level_string = 'MPI_THREAD_SINGLE'
   case (MPI_THREAD_FUNNELED)
      required_level_string = 'MPI_THREAD_FUNNELED'
   case (MPI_THREAD_SERIALIZED)
      required_level_string = 'MPI_THREAD_SERIALIZED'
   case (MPI_THREAD_MULTIPLE)
      required_level_string = 'MPI_THREAD_MULTIPLE'
   case default
      required_level_string = 'Unknown'
   end select

   ! Initilialise MPI and ask for thread support
   write (*,*) 'Initialising MPI with required threading support level: ', trim(required_level_string)
   call MPI_Init_thread(required_level, provided, ierror)
   write (*,*) 'MPI_Init_thread returned with provided threading support level: ', provided
   if (provided < required_level) then
      write(*,'(A)') 'The threading support level is lesser than that demanded.'
      call MPI_Abort(MPI_COMM_WORLD, -1, ierror)
   else
      write(*,'(A)') 'The threading support level is greater than or equal to that demanded.'
   end IF

   ! Tell MPI to shut down.
   call MPI_Finalize(ierror)
end program main
