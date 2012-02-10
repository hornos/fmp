! FORTRAN Multi Processor
#include "fmp.h"

module fmp
  implicit none
  include 'mpif.h'

#include "fmpcom.h"

  contains

  subroutine fmp_mpi_init(com,ierr)
    implicit none
    integer :: rc,ierr
    type(fmpcom) :: com

    call mpi_init(ierr)
    FMP_MPI_FAILED(ierr) then
      call mpi_abort(MPI_COMM_WORLD,rc,ierr)
      return
    FMP_MPI_END

    ! global communicator
    com%mpi_com = MPI_COMM_WORLD

    ! rank
    call mpi_comm_rank(com%mpi_com,com%mpi_rank,ierr)
    FMP_MPI_FAILED(ierr) &
      return

    ! size
    call mpi_comm_size(com%mpi_com,com%mpi_size,ierr)
    FMP_MPI_FAILED(ierr) &
      return

    ! master
    com%mpi_master = FMP_MPI_RANK_MASTER

    ! io
    FMP_STDIN(com)  = FMP_UNIT_STDIN
    FMP_STDOUT(com) = FMP_UNIT_STDOUT
    FMP_STDERR(com) = FMP_UNIT_STDERR
  end subroutine fmp_mpi_init


  subroutine fmp_omp_init(com,ierr)
    implicit none
    integer :: ierr
    integer :: omp_get_max_threads
    type(fmpcom) :: com
    com%omp_size=omp_get_max_threads()
  end subroutine fmp_omp_init


  subroutine fmp_gpu_init(com,ierr)
    implicit none
    integer :: ierr
    type(fmpcom) :: com
#ifdef CUDA
    print*,'CUDA not implemented'
#else
    com%gpu_size=1
#endif
    com%gpu_rank=mod(com%mpi_size,com%gpu_size)
  end subroutine fmp_gpu_init


  subroutine fmp_mpi_finalize
    implicit none
    integer :: ierr

    call mpi_finalize(ierr)
    FMP_MPI_FAILED(ierr) &
      return
  end subroutine fmp_mpi_finalize


  subroutine fmp_whoami(com)
    implicit none
    type(fmpcom) :: com
    write(*,'(X,"fmp_mpi_whoami",I5,I5,I5,I5)') &
    com%mpi_rank,com%mpi_size,com%omp_size,com%gpu_size
  end subroutine fmp_whoami


  subroutine fmp_mpi_sleep(sec)
    implicit none
    real :: sec
    real,dimension(2) :: t

    call cpu_time(t(1))
    do while (t(2)-t(1).lt.sec)
      call cpu_time(t(2))
    end do
  end subroutine fmp_mpi_sleep

end module fmp
