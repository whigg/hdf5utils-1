Example use of libhdf5utils
===========================

Get the distribution as a `tar.gz` archive, e.g. for macOS and gfortran it is
called `libhdf5utils-Darwin-gfortran.tar.gz`. Then extract it:

```bash
tar xvzf libhdf5util-Darwin-gfortran.tar.gz
```

This puts the following files into the directory:

+ `hdf5utils.mod`
+ `libhdf5utils.f90`
+ `libhdf5utils.so`
+ `README`

Compile the example program and run it:

```bash
make
./a.out
```

See notes below for details.

Test reading the output in IPython:

```python
>>> import h5py
>>> f = h5py.File('test.h5')
>>> f['header']['value'][()]
1234.0
```

Notes on example Makefile
-------------------------

This is what the Makefile in this example is doing...

To use the library compile the interface module `libhdf5utils.f90` (here we're
using gfortran):

```
gfortran -c libhdf5utils.f90
```

Then, when compiling your program, include the directory with `hdf5utils.mod`
and `libhdf5utils.mod.` For example

    gfortran -c -I$(INCLUDE_DIR) ...

Then, when linking your program, link to `libhdf5utils.so` and include the
directory. For example

    gfortran -o your_program *.o -L$(LIBRARY_DIR) -lhdf5utils
