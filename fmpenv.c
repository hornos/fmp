#include <stdlib.h>

// environment MPI_PPN
// for MPI multi-GPU setup
void fmp_mpi_get_ppn_( int *ppn, int *ierr ) {
  char *env;
  *ppn  = 1;
  *ierr = 0;
  env = getenv( "FMP_MPI_PERNODE" );
  if( env != NULL )
    *ppn = atoi( env );
}

