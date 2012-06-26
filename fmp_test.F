#include "fmp.h"

program fmp_test
  use fmp
  implicit none

  integer :: ierr
  type(fmpcom) :: com

  ! MPI
  call fmp_mpi_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    write(*,'(X,I3,X,"ERR fmp_mpi_init: ",I4)'),com%mpi_rank,ierr
    call fmp_mpi_abort()
    stop
  FMP_END

  ! OMP
  call fmp_omp_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    write(*,'(X,I3,X,"ERR fmp_omp_init: ",I4)'),com%mpi_rank,ierr
    call fmp_mpi_finalize(ierr)
    stop
  FMP_END

  ! GPU
  call fmp_gpu_init(com,ierr)
  FMP_MPI_FAILED(ierr) then
    write(*,'(X,I3,X,"ERR fmp_gpu_init: ",I4)'),com%mpi_rank,ierr
    call fmp_mpi_finalize(ierr)
    stop
  FMP_END

  ! work
  ! call fmp_mpi_sleep(com,10.0)
  ! FMP_MPI_BARRIER(com,ierr)

  call fmp_mpi_finalize(ierr)
  stop

end program
