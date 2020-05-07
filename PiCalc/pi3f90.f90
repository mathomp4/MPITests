!**********************************************************************
!   pi3f90.f - compute pi by integrating f(x) = 4/(1 + x**2)     
!
!  (C) 2001 by Argonne National Laboratory.
!      See COPYRIGHT in top-level directory.
!     
!   Each node: 
!    1) receives the number of rectangles used in the approximation.
!    2) calculates the areas of it's rectangles.
!    3) Synchronizes for a global summation.
!   Node 0 prints the result.
!
!  Variables:
!
!    pi  the calculated result
!    n   number of points of integration.  
!    x           midpoint of each rectangle's interval
!    f           function to integrate
!    sum,pi      area of rectangles
!    tmp         temporary scratch space for global summation
!    i           do loop index
!****************************************************************************
program main

   use mpi_f08
   use iso_fortran_env

   real(real64), parameter :: PI25DT = 3.141592653589793238462643d0

   real(real64)   :: mypi, pi, h, sum, x
   integer(int32) :: myid, numprocs
   integer(int64) :: n,i

   type(MPI_Comm) :: comm

   comm = MPI_COMM_WORLD
   
   call MPI_INIT( ierr )
   call MPI_COMM_RANK( comm, myid, ierr )
   call MPI_COMM_SIZE( comm, numprocs, ierr )
   print *, 'Process ', myid, ' of ', numprocs, ' is alive'
   
   n = 40000000000

   if (myid .eq. 0) then
      write (*,*) "Running ", n, " intervals."
   end if
      
   call MPI_BCAST(n,1,MPI_INTEGER,0,comm,ierr)

   h = 1.0d0/n

   sum  = 0.0d0
   do i = myid+1, n, numprocs
      x = h * (dble(i) - 0.5d0)
      sum = sum + f(x)
   enddo
   mypi = h * sum

!                                 collect all the partial sums
   call MPI_REDUCE(mypi,pi,1,MPI_DOUBLE_PRECISION,MPI_SUM,0, &
                  comm,ierr)

!                                 node 0 prints the answer.
   if (myid .eq. 0) then
      write(6, 97) pi, abs(pi - PI25DT)
97     format('  pi is approximately: ', F19.16, &
               '  Error is: ', F19.16)
   endif

   call MPI_FINALIZE(ierr)

   contains

   real(real64) function f(a)
      real(real64), intent(in) :: a

      f = 4.d0 / (1.d0 + a**2)
   end function f
end




