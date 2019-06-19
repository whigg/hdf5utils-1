Utilities for reading and writing HDF5 files in Fortran
=======================================================

To make use of this library, first compile it and make an archive to distribute:

```
cd src
make dist
```

This makes a file `libhdf5utils.tar.gz` with the shared object library
`libhdf5utils.so`, a Fortran interface file `libhdf5utils.f90`, and the required
Fortran module file `hdf5utils.mod` (which is compiler dependent).

You can then distribute the `libhdf5utils.tar.gz` file, and then use the library
in your application by following the `README` contained within.
