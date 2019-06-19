Utilities for reading and writing HDF5 files in Fortran
=======================================================

Make the library
----------------

To make use of this library, first compile it and make an archive to distribute:

```
cd src
make
```

Note that you may want to change the compiler, and specify the location of the
HDF5 libraries:

```
make FC=ifort HDF5ROOT=/usr/local/hdf5-1.10.5
```

Alternatively, if the HDF5 library and include files are in different locations
you can set `HDF5INCLUDE` and `HDF5LIB` separately.

This makes a file `libhdf5utils-OS-FC.tar.gz` (where `OS` is either `Darwin` or
`Linux`, and `FC` is either `ifort` or `gfortran`) with the shared object
library `libhdf5utils.so`, a Fortran interface file `libhdf5utils.f90`, and the
required Fortran module file `hdf5utils.mod` (which is compiler dependent).

Use the library
---------------

You can then distribute the archive file, and then use the library in your
application by following the `README` contained within.

See the example folder for an example.
