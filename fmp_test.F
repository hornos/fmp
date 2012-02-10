#include "fmp.h"

program fmp_test
  use fmp
  implicit none
  integer :: ierr
  type(fmpcom) :: com
  call fmp_mpi_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    print*,"fmp_mpi_init:",ierr
    stop
  FMP_MPI_END

  call fmp_omp_init(com,ierr)
  call fmp_gpu_init(com,ierr)

  FMP_MPI_MASTER(com) then
    write(*,'(/,"# of MPI processes =",I6)'),com%mpi_size
  FMP_MPI_END
  write(*,'(I6,"  # of OMP threads =",I6)'),com%mpi_rank,com%omp_size
  write(*,'(I6,"  # of GPU cards   =",I6)'),com%mpi_rank,com%gpu_size
  write(*,'(I6,"  # of GPU rank    =",I6)'),com%mpi_rank,com%gpu_rank

  call fmp_mpi_finalize()
end program
