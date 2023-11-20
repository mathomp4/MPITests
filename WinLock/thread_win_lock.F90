program main
   use mpi
   use, intrinsic :: iso_c_binding, only: c_ptr, c_f_pointer
   implicit none

   integer :: comms(0:1)
   integer :: rank
   integer :: ierror
   integer :: npes, sizeof_integer
   integer(kind=MPI_ADDRESS_KIND) :: sz, disp
   integer, pointer :: buffer(:,:)
   type (c_ptr) :: base_address

   integer :: i, nthreads
   integer, allocatable :: x(:,:), y
   integer :: window
   integer :: provided
   integer, external :: omp_get_thread_num

   call MPI_Init_thread(MPI_THREAD_MULTIPLE, provided, ierror)
!!$   call MPI_Init_thread(MPI_THREAD_SINGLE, provided, ierror)
   nthreads = 2

   !$omp parallel num_threads(2) default(none), shared(comms), private(ierror,i)
   i = omp_get_thread_num()
   if (i == 0) then
      call MPI_Comm_dup(MPI_COMM_WORLD, comms(i), ierror)
   end if
   !$omp barrier
   if (i == 0) then
      call MPI_Comm_dup(MPI_COMM_WORLD, comms(i), ierror)
   end if
   !$omp end parallel

   call MPI_Comm_rank(comms(0), rank, ierror)
   call MPI_Type_extent(MPI_INTEGER, sizeof_integer, ierror)
   call MPI_Comm_size(comms(0), npes, ierror)

   if (rank == 0) then ! create  buffer
      sz = npes * nthreads * sizeof_integer
      call MPI_Alloc_mem(sz, MPI_INFO_NULL, base_address, ierror)
      call c_f_pointer(base_address, buffer, [nthreads,npes])
      buffer = -1
      call MPI_Win_create(buffer, sz, sizeof_integer, MPI_INFO_NULL, comms(0), window, ierror)
   else
      sz = 0
      allocate(buffer(1,1))
      call MPI_Win_create(buffer, sz, sizeof_integer, MPI_INFO_NULL, comms(0), window, ierror)
   end if

   call MPI_Win_Fence(0, window, ierror)

   !$omp parallel num_threads(2) default(none), shared(rank, window, npes, nthreads), &
   !$omp& private(disp, x, y, ierror,i)
   i = omp_get_thread_num()

   !$omp critical
   call MPI_Win_lock(MPI_LOCK_EXCLUSIVE, 0, 0, window, ierror)
        disp = 0
        allocate(x(nthreads,npes))
        call MPI_Get(x, npes*nthreads, MPI_INTEGER, 0, disp, npes*nthreads, MPI_INTEGER, window, ierror)
        y = rank
        disp =  i + nthreads*rank
        call MPI_Put(y, 1, MPI_INTEGER, 0, disp, 1, MPI_INTEGER, window, ierror)
        deallocate(x)
    call MPI_Win_unlock(0, window, ierror)
    !$omp end critical
    !$omp end parallel

    call MPI_Barrier(comms(0), ierror)

   ! Check result
   if (rank == 0) then
      call c_f_pointer(base_address, buffer, [nthreads,npes])
      print*,''
      print*, 'result: ', buffer
      print*, 'expected: ', [0,0,1,1,2,2,3,3]
      call MPI_Free_mem(buffer, ierror)
   end if
   call MPI_win_free(window, ierror)

   call MPI_Finalize(ierror)
   
end program main
