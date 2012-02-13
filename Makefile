.SUFFIXES: .F .f90 .c

include arch.make

# Fortran modules
C_SRC  = fmpenv.c
C_OBJ  = $(C_SRC:.c=.o)

F_SRC  = fmp.F
F_MOD  = $(F_SRC:.F=.mod)
F_OBJ  = $(F_SRC:.F=.o)

EXE    = fmp_test
LIB    = fmp.a

all: $(LIB) $(EXE)

$(LIB): $(F_OBJ) $(C_OBJ)
	ar vq $(LIB) $(F_OBJ) $(C_OBJ)

$(EXE): $(F_MOD) $(EXE).o
	$(FC) $(LDFLAGS) -o $(EXE) $(EXE).o $(LIB)

.c.o:
	@echo "\nC Object:" $@
	$(CC) -c $(CFLAGS) $< -o $@

.F.o:
	@echo "\nF Object:" $@
	$(CPP)
	$(FC) $(FFLAGS) -c $*.f90 -o $@

.F.mod:
	@echo "\nF Module:" $@
	$(CPP)
	$(FC) $(FFLAGS) -c $*.f90

clean:
	rm -f *.o *.a *.mod *.f90
