Example use of libhdf5utils
===========================

Get the distribution, e.g. for macOS and gfortran:

```bash
cd ../src
make dist
cp libhdf5utils-Darwin-gfortran.tar.gz ../example
cd ../example
tar xvzf libhdf5util-Darwin-gfortrans.tar.gz
```

Compile the example program and run it:

```bash
make
./a.out
```

Test reading the output in IPython:

```python
>>> import h5py
>>> f = h5py.File('test.h5')
>>> f['header']['value'][()]
1234.0
```
