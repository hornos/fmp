#include "fmp.h"

program fmp_test
  use fmp
  implicit none

  integer :: ierr
  type(fmpcom) :: com

  ! MPI
  call fmp_mpi_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    print*,"fmp_mpi_init:",ierr
    call fmp_mpi_abort()
    stop
  FMP_END
  call fmp_info(com,ierr)

  ! OMP
  call fmp_omp_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    print*,"fmp_omp_init:",ierr
    call fmp_mpi_finalize(ierr)
    stop
  FMP_END
  call fmp_info(com,ierr)


  ! GPU
  call fmp_gpu_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    print*,"fmp_gpu_init:",ierr
    call fmp_mpi_finalize(ierr)
    stop
  FMP_END
  call fmp_info(com,ierr)

  call fmp_mpi_finalize(ierr)
  stop

end program
