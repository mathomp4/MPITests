program main
   use mpi
   implicit none

   integer :: ierror, n, subversion, version, first_space
   character(MPI_MAX_LIBRARY_VERSION_STRING) :: version_string

   call MPI_Get_library_version(version_string, n, ierror)

   first_space = index(version_string, " ")
   print*, version_string(1:first_space)
end program main
