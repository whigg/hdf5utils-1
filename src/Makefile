#
# HDF5 utils for Phantom, MCFOST, etc.
#
# HDF5 libraries requires two directories:
#   - include for Fortran .mod files
#   - lib for the shared library .so files
#
# Often both directories are under one root,
# e.g. HDF5ROOT= /usr/local/opt/hdf5
# In this case just set HDF5ROOT for your machine.
#
# However, sometimes these directories are separate,
# then you must set both HDF5INCLUDE and HDF5LIB.
#
# Daniel Mentiplay, 2019.
#

FC      = gfortran
FCFLAGS = -O3 -fPIC
FLFLAGS = -shared

ifeq (X$(HDF5ROOT), X)
    HDF5ROOT= /usr/local/opt/hdf5
endif
ifeq (X$(HDF5INCLUDE), X)
    HDF5INCLUDE= $(HDF5ROOT)/include
endif
ifeq (X$(HDF5LIB), X)
    HDF5LIB= $(HDF5ROOT)/lib
endif
FCFLAGS+= -I$(HDF5INCLUDE)
FLFLAGS+= -L$(HDF5LIB) -lhdf5 -lhdf5_fortran

%.o : %.f90
	$(FC) -c $(FCFLAGS) $< -o $@

FSOURCES = hdf5utils.f90
OBJECTS = $(FSOURCES:.f90=.o)

default: dist

libhdf5utils: $(OBJECTS)
	@echo
	@echo " Linking HDF5 utils into a shared object library"
	@echo
	$(FC) $(FCFLAGS) $(FLFLAGS) $(OBJECTS) -o libhdf5utils.so

dist: libhdf5utils
	@echo
	@echo " Packing up HDF5 utils in tar.gz"
	@echo
	tar cvzf libhdf5utils.tar.gz libhdf5utils.so libhdf5utils.f90 hdf5utils.mod README

.PHONY: clean
clean:
	@echo
	@echo " Removing Fortran build files"
	@echo
	@rm -f *.o *.mod *.so *.dSYM

.PHONY: cleandist
cleandist:
	@echo
	@echo " Removing Fortran build files and distribution files"
	@echo
	@rm -f *.o *.mod *.so *.dSYM *.tar.gz
