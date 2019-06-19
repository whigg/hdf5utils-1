Files in libhdf5utils.tar.gz:

  - hdf5utils.mod
  - libhdf5utils.so
  - libhdf5utils.f90
  - README

To use the library compile libhdf5utils.f90 using the same compiler that you use
to compile your code (e.g. using gfortran):

    gfortran -c libhdf5utils.f90

Then, when compiling your program, include the directory with hdf5utils.mod and
libhdf5utils.mod. For example

    gfortran -c -I$(INCLUDE_DIR) ...

Then, when linking your program, link to libhdf5utils.so and include the
directory. For example

    gfortran -o your_program *.o -L$(LIBRARY_DIR) -lhdf5utils
