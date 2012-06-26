#define FMPCOM_SIZE 256
#define FMPCOM_MAX   16

type fmpcom
  integer :: mpi_com
  integer :: mpi_rank
  integer :: mpi_master
  integer,dimension(FMPCOM_SIZE) :: mpi_io

  ! mpirun -np
  ! # of MPI procs
  integer :: mpi_size
  integer :: mpi_pernode

  ! OMP_NUM_THREADS
  ! # of OMP threads per MPI proc
  integer :: omp_size

  ! count (dimension) of CUDA_VISIBLE_DEVICES per node
  ! physical set of GPUs: (pi,pj,pk...)
  ! per proc visible set: (0,1,2...)
  integer :: gpu_size
  integer :: gpu_perproc

  integer,dimension(FMPCOM_MAX) :: gpu_rank

end type fmpcom
