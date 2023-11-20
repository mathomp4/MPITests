program main
   use mpi
   use iso_c_binding, only: C_PTR

   integer(kind=MPI_ADDRESS_KIND) :: sz
   type (c_ptr) :: ptr
   
   call MPI_Alloc_mem(sz, MPI_INFO_NULL, ptr, ierror)
   
end program main

