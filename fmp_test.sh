#!/bin/bash
gbn=$(basename ${BASH_SOURCE})
gbn=${gbn%%.sh}

### mpi
_np=${1}
_ppn=${2}
_prerun=""

if ! test -z "${_np}" ; then
  _prerun="mpirun -np ${_np}"
fi

if ! test -z "${_ppn}" ; then
  export FMP_MPI_PERNODE=${_ppn}
fi

if test "${OSTYPE##darwin}" = "${OSTYPE}" ; then
  # linux
  LD_LIBRARY_PATH="${CUDA_HOME:-/opt/cuda}/lib"
else
  # osx
  DYLD_LIBRARY_PATH="${CUDA_HOME:-/usr/local/cuda}/lib"
fi

${_prerun} ./${gbn} $*
