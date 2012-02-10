! !$omp master
#define FMP_MPI_MASTER(COM)   if(COM%mpi_rank.eq.COM%mpi_master)
#define FMP_MPI_SUCCESS(IERR) if(IERR.eq.MPI_SUCCESS)
#define FMP_MPI_FAILED(IERR)  if(IERR.ne.MPI_SUCCESS)
#define FMP_MPI_END           endif

#define FMP_STDIN(COM)        COM%mpi_io(1)
#define FMP_STDERR(COM)       COM%mpi_io(2)
#define FMP_STDOUT(COM)       COM%mpi_io(3)

#define FMP_UNIT_STDIN        10
#define FMP_UNIT_STDOUT       15
#define FMP_UNIT_STDERR       16

#define FMP_MPI_RANK_MASTER    0
