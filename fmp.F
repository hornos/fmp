! FORTRAN Multi Processor
#include "fmp.h"

#ifdef FUDA
#include "cudaerror.h"
#endif

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
    FMP_END

    ! global communicator
    com%mpi_com = MPI_COMM_WORLD

    ! size
    call mpi_comm_size(com%mpi_com,com%mpi_size,ierr)
    FMP_MPI_FAILED(ierr) &
      return

    ! ppn
    call fmp_mpi_get_ppn(com%mpi_ppn,ierr)
    FMP_MPI_FAILED(ierr) &
      return

    ! rank
    call mpi_comm_rank(com%mpi_com,com%mpi_rank,ierr)
    FMP_MPI_FAILED(ierr) &
      return

    ! master
    com%mpi_master = FMP_MPI_RANK_MASTER

    ! io
    FMP_STDIN(com)  = FMP_UNIT_STDIN
    FMP_STDOUT(com) = FMP_UNIT_STDOUT
    FMP_STDERR(com) = FMP_UNIT_STDERR

    ! omp gpu
    com%omp_size = 1
    com%gpu_gpp  = 1
    com%gpu_size = 1
    com%gpu_rank = 0

  end subroutine fmp_mpi_init


  subroutine fmp_omp_init(com,ierr)
    implicit none
    integer :: ierr
    integer :: omp_get_max_threads
    type(fmpcom) :: com
    com%omp_size = omp_get_max_threads()
  end subroutine fmp_omp_init


  subroutine fmp_gpu_init(com,ierr)
#ifdef FUDA
    use fudadevice
    use fudaerror
#endif
    implicit none
    integer :: i,ierr
    character(len=80) :: buf
    type(fmpcom) :: com

#ifdef FUDA
    call fudaGetDeviceCount(com%gpu_size,ierr)
    FMP_GPU_FAILED(ierr) &
      return
#else
    com%gpu_gpp  = 1
    com%gpu_size = 1
#endif
    ! check proc-gpu ratio
    if(com%mpi_ppn.gt.com%gpu_size) then
      ierr = 10
      return
    end if
    ! gpus per mpi procs per node
    com%gpu_gpp = com%gpu_size / com%mpi_ppn

    ! gpu rank is a vector
    com%gpu_rank = 0
    do i = 0, com%gpu_gpp - 1
      com%gpu_rank(i+1) = i + mod(com%mpi_rank,com%mpi_ppn)
    end do

#ifdef FUDA
    ! set the first device
    call fudaSetDevice(com%gpu_rank(1),ierr)
    FMP_GPU_FAILED(ierr) &
      return
#endif

  end subroutine fmp_gpu_init


  subroutine fmp_mpi_finalize(ierr)
    implicit none
    integer :: ierr

    call mpi_finalize(ierr)
    FMP_MPI_FAILED(ierr) &
      return
  end subroutine fmp_mpi_finalize


  subroutine fmp_mpi_abort
    implicit none

    call mpi_abort()
  end subroutine fmp_mpi_abort


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


  subroutine fmp_info(com,ierr)
    implicit none
    type(fmpcom) :: com
    integer :: ierr

    FMP_MPI_BARRIER(com,ierr)

    write(*,'(/,"FMP node info")')
    write(*,'("----------------------------------------------------")')
    write(*,'("rank   # of")')
    write(*,'(I4,2X," MPI procs   =",I4)'),com%mpi_rank,com%mpi_size
    write(*,'(I4,2X," MPI pernode =",I4)'),com%mpi_rank,com%mpi_ppn
    write(*,'(I4,2X," OMP threads =",I4)'),com%mpi_rank,com%omp_size
    write(*,'(I4,2X," GPU cards   =",I4)'),com%mpi_rank,com%gpu_size
    write(*,'(I4,2X," GPU perproc =",I4)'),com%mpi_rank,com%gpu_gpp
    write(*,'(I4,2X," GPU rank    =",8I4)'),com%mpi_rank,com%gpu_rank
    write(*,'("----------------------------------------------------",/)')
    FMP_MPI_BARRIER(com,ierr)
  end subroutine

end module fmp
