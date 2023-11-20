program main
   use mpi_f08
   use iso_fortran_env

   implicit none

   integer :: ierror, n_psets, i
   integer :: myid, npes
   integer :: name_length
   integer :: version, subversion, resultlen

   integer, allocatable :: pset_len(:)

   character(len=MPI_MAX_PSET_NAME_LEN), allocatable :: pset_names(:), dummy
   character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name
   character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: version_string

   TYPE(MPI_Session) :: shandle
   TYPE(MPI_Group) :: pgroup
   TYPE(MPI_Comm) :: pcomm

   ! Note that this code is rather shamelessly based on 
   ! the example from:
   ! https://github.com/open-mpi/ompi-tests-public/blob/master/sessions/sessions_ex3.f90

   call MPI_Session_init(MPI_INFO_NULL, MPI_ERRORS_RETURN, &
                        shandle, ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Session_init failed"
      ERROR STOP
   end if

   call MPI_Session_get_num_psets(shandle, MPI_INFO_NULL, n_psets)
   IF (n_psets .lt. 2)  THEN
      write(*,*) "MPI_Session_get_num_psets didn't return at least 2 psets"
      ERROR STOP
   endif

   ! Now we know how many psets there are, we can allocate the array
   ! to hold the pset names
   ! NOTE: Sessions are index-zero even in Fortran

   allocate(pset_len(0:n_psets-1), source=0)

   ! Now we can get the pset lengths so we can 
   ! figure out the longest pset name so we can allocate
   ! a buffer to hold the pset names

   do i = 0, n_psets-1
      call MPI_Session_get_nth_pset(shandle, MPI_INFO_NULL, i, pset_len(i), dummy)
   end do

   ! Now we can allocate the buffer to hold the pset names
   ! using the longest pset name length

   !allocate(pset_names(0:n_psets-1), source="")
   allocate(pset_names(0:n_psets-1))
   do i = 0, n_psets-1
      pset_names(i) = ""
      call MPI_Session_get_nth_pset(shandle, MPI_INFO_NULL, i, pset_len(i), pset_names(i))
   end do

   ! Now let's assume/hope one of the sessions is mpi://WORLD
   ! and let's create a group from that pset

   call MPI_Group_from_session_pset(shandle, "mpi://WORLD", pgroup)

   call MPI_Comm_create_from_group(pgroup, "session_example", MPI_INFO_NULL, MPI_ERRORS_RETURN, pcomm)

   ! Now let's do our usual hello world

   call MPI_Get_version(version, subversion, ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Get_version failed"
      ERROR STOP
   end if

   call MPI_Get_library_version(version_string, resultlen, ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Get_library_version failed"
      ERROR STOP
   end if

   call MPI_Comm_Rank(pcomm,myid,ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Comm_Rank failed"
      ERROR STOP
   end if

   call MPI_Comm_Size(pcomm,npes,ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Comm_Size failed"
      ERROR STOP
   end if

   call MPI_Get_Processor_Name(processor_name,name_length,ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Get_Processor_Name failed"
      ERROR STOP
   end if

   if (myid == 0) then
      write (output_unit,'("Compiler Version:",X,A)') trim(compiler_version())
      write (output_unit,'("MPI Version:",X,I1,".",I1)') version, subversion
      write (output_unit,'("MPI Library Version:",X,A)') trim(version_string)

      ! Now let's print out the array of pset names just because I'm not sure what they are...
      do i = 0, n_psets-1
         write(*,*) "Pset ", i, " name: ", trim(pset_names(i))
      end do
   
   end if

   call MPI_Barrier(pcomm, ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Barrier failed"
      ERROR STOP
   end if

   write (output_unit,'(A,X,I4,X,A,X,I4,X,A,X,A)') "Process", myid, "of", npes, "is on", trim(processor_name)

   call MPI_Comm_free(pcomm)

   call MPI_Group_free(pgroup)

   call MPI_Session_finalize(shandle, ierror)
   if (ierror .ne. MPI_SUCCESS) THEN
      write(*,*) "MPI_Session_finalize failed"
      ERROR STOP
   end if

end program main

