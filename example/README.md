Example use of libhdf5utils
===========================

Get the distribution, e.g.:

```
cd ../src
make dist
cp libhdf5utils.tar.gz ../example
cd ../example
tar xvzf libhdf5utils.tar.gz
```

Compile the example program and run it:

```
make
./a.out
```

Test reading the output in IPython:

```
In [1]: import h5py

In [2]: f = h5py.File('test.h5')

In [3]: f['header']['value'][()]
Out[3]: 1234.0
```
