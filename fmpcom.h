type fmpcom
  integer :: mpi_com
  integer :: mpi_rank
  integer :: mpi_master
  integer,dimension(256) :: mpi_io
  ! -np
  integer :: mpi_size

  ! from OMP_NUM_THREADS
  integer :: omp_size

  ! from CUDA_VISIBLE_DEVICES
  integer :: gpu_size
  ! mod(mpi_size,gpu_size)
  integer :: gpu_rank
end type fmpcom
