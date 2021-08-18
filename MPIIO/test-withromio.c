#include <stdio.h>
#include "mpi.h"

int main ( int argc, char ** argv)
{
    int rank, size, ret;
    int val;
    MPI_File fh;
    MPI_Status status;
    MPI_Info info;

    MPI_Init ( &argc, &argv );
    MPI_Comm_rank ( MPI_COMM_WORLD, &rank );
    MPI_Comm_size ( MPI_COMM_WORLD, &size );

    MPI_Info_create ( &info );
    MPI_Info_set ( info, "romio_cb_read", "automatic" );
    MPI_Info_set ( info, "cb_buffer_size", "1048576" );
    MPI_File_open (MPI_COMM_WORLD, "test.out", MPI_MODE_RDONLY, info, &fh);
    ret = MPI_File_read (fh, &val, 1, MPI_INT, &status );
    if ( ret != MPI_SUCCESS ) {
        printf("Error while writing file. Aborting\n");
        MPI_Abort ( MPI_COMM_WORLD, 1 );
    }

    MPI_File_close ( &fh);
    MPI_Info_free ( &info );
    MPI_Finalize ();
    return 0;
}

