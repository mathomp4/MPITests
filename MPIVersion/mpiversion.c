# include <stdlib.h>
# include <stdio.h>
# include <time.h>
# include "mpi.h"

int main(int argc, char *argv[])
{
   char mpi_lib_ver[MPI_MAX_LIBRARY_VERSION_STRING];
   int len;
   MPI_Get_library_version(mpi_lib_ver, &len);
   printf("%s\n",mpi_lib_ver);
}
