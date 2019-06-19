#
# Example use case for libhdf5utils.
#
# Daniel Mentiplay, 2019.
#

FC      = gfortran
FCFLAGS = -O3
FLFLAGS =

FCFLAGS+= -I.
FLFLAGS+= -L. -lhdf5utils

%.o : %.f90
	$(FC) -c $(FCFLAGS) $< -o $@

FSOURCES = libhdf5utils.f90
OBJECTS = $(FSOURCES:.f90=.o)

main: hdf5utils.mod libhdf5utils.o libhdf5utils.so
	$(FC) prog.f90 -L. -lhdf5utils

hdf5utils.mod:
	@echo
	@echo " Get hdf5utils.mod from libhdf5utils"
	@echo " and make sure the compiler version is consistent"
	@echo

libhdf5utils.so:
	@echo
	@echo " Get libhdf5utils.so from libhdf5utils"
	@echo

.PHONY: clean
clean:
	@echo
	@echo " Removing Fortran build files"
	@echo
	@rm -f *.o *.mod *.so *.dSYM
