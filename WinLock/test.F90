program test

   implicit none

   real :: test1, test2, test3

   namelist /sample/ test1, test2, test3

   open(123,file='sample.nml')

   read (123, nml=sample)

   write (*,*) "test1: ", test1
   write (*,*) "test2: ", test2
   write (*,*) "test3: ", test3

   close (123)
end program test
