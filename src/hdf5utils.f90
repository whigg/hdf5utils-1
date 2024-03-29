!
! hdf5utils.f90
!
! Daniel Mentiplay, David Liptai, Conrad Chan, 2019
!

module hdf5utils

  use hdf5, only: h5open_f,                    &
                  h5close_f,                   &
                  h5fcreate_f,                 &
                  h5fopen_f,                   &
                  h5fclose_f,                  &
                  h5gcreate_f,                 &
                  h5gopen_f,                   &
                  h5gclose_f,                  &
                  h5dopen_f,                   &
                  h5dread_f,                   &
                  h5dread_vl_f,                &
                  h5dcreate_f,                 &
                  h5dclose_f,                  &
                  h5dwrite_f,                  &
                  h5lexists_f,                 &
                  h5screate_f,                 &
                  h5sclose_f,                  &
                  h5screate_simple_f,          &
                  h5tcopy_f,                   &
                  h5tset_size_f,               &
                  h5tclose_f,                  &
                  h5dget_type_f,               &
                  h5tget_size_f,               &
                  h5dget_space_f,              &
                  h5sget_simple_extent_dims_f, &
                  HID_T,                       &
                  H5F_ACC_TRUNC_F,             &
                  H5F_ACC_RDWR_F,              &
                  HSIZE_T,                     &
                  H5S_SCALAR_F,                &
                  H5T_NATIVE_REAL,             &
                  H5T_NATIVE_DOUBLE,           &
                  H5T_NATIVE_INTEGER,          &
                  H5T_STD_I8LE,                &
                  SIZE_T,                      &
                  H5T_FORTRAN_S1,              &
                  C_PTR

 use iso_c_binding, only:c_loc

 implicit none

 private

 public :: write_real_kind4,             & ! real(4)
           write_real_kind8,             & ! real(8)
           write_real_1d_array_kind4,    & ! 1d real(4) arrays
           write_real_1d_array_kind8,    & ! 1d real(8) arrays
           write_real_2d_array_kind4,    & ! 2d real(4) arrays
           write_real_2d_array_kind8,    & ! 2d real(8) arrays
           write_real_3d_array_kind4,    & ! 3d real(4) arrays
           write_real_3d_array_kind8,    & ! 3d real(8) arrays
           write_integer_kind4,          & ! integer(4)
           write_integer_1d_array_kind1, & ! 1d integer(1) arrays
           write_integer_1d_array_kind4, & ! 1d integer(4) arrays
           write_string,                 & ! strings
           read_real_kind4,              & ! real(4)
           read_real_kind8,              & ! real(8)
           read_real_1d_array_kind4,     & ! 1d real(4) arrays
           read_real_1d_array_kind8,     & ! 1d real(8) arrays
           read_real_2d_array_kind4,     & ! 2d real(4) arrays
           read_real_2d_array_kind8,     & ! 2d real(8) arrays
           read_real_3d_array_kind4,     & ! 3d real(4) arrays
           read_real_3d_array_kind8,     & ! 3d real(8) arrays
           read_integer_kind4,           & ! integer(4)
           read_integer_1d_array_kind1,  & ! 1d integer(1) arrays
           read_integer_1d_array_kind4,  & ! 1d integer(4) arrays
           read_string,                  & ! strings
           open_hdf5file,                &
           close_hdf5file,               &
           create_hdf5file,              &
           open_hdf5group,               &
           close_hdf5group,              &
           create_hdf5group,             &
           HID_T

contains

subroutine create_hdf5group(file_id,groupname,group_id,error)
  character(len=*), intent(in)  :: groupname
  integer(HID_T),   intent(in)  :: file_id
  integer(HID_T),   intent(out) :: group_id
  integer,          intent(out) :: error
  call h5gcreate_f(file_id,groupname,group_id,error)
end subroutine create_hdf5group

subroutine open_hdf5group(file_id,groupname,group_id,error)
  character(len=*), intent(in)  :: groupname
  integer(HID_T),   intent(in)  :: file_id
  integer(HID_T),   intent(out) :: group_id
  integer,          intent(out) :: error
  call h5gopen_f(file_id,groupname,group_id,error)
end subroutine open_hdf5group

subroutine close_hdf5group(group_id,error)
  integer(HID_T),   intent(in) :: group_id
  integer,          intent(out) :: error
  call h5gclose_f(group_id,error)
end subroutine close_hdf5group

subroutine create_hdf5file(filename,file_id,error)
  character(len=*), intent(in)  :: filename
  integer(HID_T),   intent(out) :: file_id
  integer,          intent(out) :: error
  integer :: errors(2)
  call h5open_f(errors(1))                                     ! Initialise h5
  call h5fcreate_f(filename,H5F_ACC_TRUNC_F,file_id,errors(2)) ! Create file
  error = maxval(abs(errors))
end subroutine create_hdf5file

subroutine open_hdf5file(filename,file_id,error)
  character(len=*), intent(in)  :: filename
  integer(HID_T),   intent(out) :: file_id
  integer,          intent(out) :: error
  integer :: errors(2)
  call h5open_f(errors(1))                                     ! Initialise h5
  call h5fopen_f(filename,H5F_ACC_RDWR_F,file_id,errors(2))    ! Open file
  error = maxval(abs(errors))
end subroutine open_hdf5file

subroutine close_hdf5file(file_id,error)
  integer(HID_T), intent(in)  :: file_id
  integer,        intent(out) :: error
  integer :: errors(2)
  call h5fclose_f(file_id,errors(2)) ! Close the file
  call h5close_f(errors(1))          ! Close Fortran h5 interfaces
  error = maxval(abs(errors))
end subroutine close_hdf5file

subroutine write_real_kind4(x,name,id,error)
  real(kind=4),   intent(in)  :: x
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dspace_id
  integer(HID_T) :: dset_id
  integer :: errors(5)

  ! Create dataspace
  call h5screate_f(H5S_SCALAR_F,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_REAL,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_kind4

subroutine write_real_kind8(x,name,id,error)
  real(kind=8),   intent(in)  :: x
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dspace_id
  integer(HID_T) :: dset_id
  integer :: errors(5)

  ! Create dataspace
  call h5screate_f(H5S_SCALAR_F,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_DOUBLE,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_kind8

subroutine write_real_1d_array_kind4(x,name,id,error)
  real(kind=4),   intent(in)  :: x(:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_REAL,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_1d_array_kind4

subroutine write_real_1d_array_kind8(x,name,id,error)
  real(kind=8),   intent(in)  :: x(:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_DOUBLE,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_1d_array_kind8

subroutine write_real_2d_array_kind4(x,name,id,error)
  real(kind=4),   intent(in)  :: x(:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 2
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_REAL,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_2d_array_kind4

subroutine write_real_2d_array_kind8(x,name,id,error)
  real(kind=8),   intent(in)  :: x(:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 2
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_DOUBLE,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_2d_array_kind8

subroutine write_real_3d_array_kind4(x,name,id,error)
  real(kind=4),   intent(in)  :: x(:,:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 3
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_REAL,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_3d_array_kind4

subroutine write_real_3d_array_kind8(x,name,id,error)
  real(kind=8),   intent(in)  :: x(:,:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  integer,        intent(out) :: error

  integer, parameter :: ndims = 3
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_DOUBLE,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_real_3d_array_kind8

subroutine write_integer_kind4(x,name,id,error)
  integer(kind=4), intent(in)  :: x
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  integer,         intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dspace_id
  integer(HID_T) :: dset_id
  integer :: errors(5)

  ! Create dataspace
  call h5screate_f(H5S_SCALAR_F,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_INTEGER,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_INTEGER,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_integer_kind4

subroutine write_integer_1d_array_kind4(x,name,id,error)
  integer(kind=4), intent(in)  :: x(:)
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  integer,         intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_NATIVE_INTEGER,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_NATIVE_INTEGER,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_integer_1d_array_kind4

subroutine write_integer_1d_array_kind1(x,name,id,error)
  integer(kind=1), intent(in)  :: x(:)
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  integer,         intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer :: errors(5)

  xshape = shape(x)

  ! Create dataspace
  call h5screate_simple_f(ndims,xshape,dspace_id,errors(1))

  ! Create dataset in file
  call h5dcreate_f(id,name,H5T_STD_I8LE,dspace_id,dset_id,errors(2))

  ! Write to file
  call h5dwrite_f(dset_id,H5T_STD_I8LE,x,xshape,errors(3))

  ! Close dataset
  call h5dclose_f(dset_id,errors(4))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(5))

  error = maxval(abs(errors))

end subroutine write_integer_1d_array_kind1

subroutine write_string(str,name,id,error)
  character(*),    intent(in), target :: str
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  integer,         intent(out) :: error

  integer, parameter :: ndims = 0
  integer(HSIZE_T)   :: sshape(ndims)
  integer(HID_T)     :: dspace_id
  integer(HID_T)     :: dset_id
  integer(SIZE_T)    :: slength
  integer(HID_T)     :: filetype
  type(C_PTR)        :: cpointer
  integer :: errors(8)

  slength = len(str)
  sshape  = shape(str)

  ! Create file datatypes. Save the string as FORTRAN string
  call h5tcopy_f(H5T_FORTRAN_S1,filetype,errors(1))
  call h5tset_size_f(filetype,slength,errors(2))

  ! Create dataspace
  call h5screate_simple_f(ndims,sshape,dspace_id,errors(3))

  ! Create the dataset in file
  call h5dcreate_f(id,name,filetype,dspace_id,dset_id,errors(4))

  ! Find C pointer
  cpointer = c_loc(str(1:1))

  ! Write to file
  call h5dwrite_f(dset_id,filetype,cpointer,errors(5))

  ! Close dataset
  call h5dclose_f(dset_id,errors(6))

  ! Closet dataspace
  call h5sclose_f(dspace_id,errors(7))

  ! Close datatype
  call h5tclose_f(filetype,errors(8))

  error = maxval(abs(errors))

end subroutine write_string

subroutine read_real_kind4(x,name,id,got,error)
  real(kind=4),   intent(out) :: x
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dset_id
  integer :: errors(3)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_kind4

subroutine read_real_kind8(x,name,id,got,error)
  real(kind=8),   intent(out) :: x
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dset_id
  integer :: errors(3)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_kind8

subroutine read_real_1d_array_kind4(x,name,id,got,error)
  real(kind=4),   intent(out) :: x(:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_1d_array_kind4

subroutine read_real_1d_array_kind8(x,name,id,got,error)
  real(kind=8),   intent(out) :: x(:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_1d_array_kind8

subroutine read_real_2d_array_kind4(x,name,id,got,error)
  real(kind=4),   intent(out) :: x(:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 2
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_2d_array_kind4

subroutine read_real_2d_array_kind8(x,name,id,got,error)
  real(kind=8),   intent(out) :: x(:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 2
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_2d_array_kind8

subroutine read_real_3d_array_kind4(x,name,id,got,error)
  real(kind=4),   intent(out) :: x(:,:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 3
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_REAL,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_3d_array_kind4

subroutine read_real_3d_array_kind8(x,name,id,got,error)
  real(kind=8),   intent(out) :: x(:,:,:)
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer, parameter :: ndims = 3
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_DOUBLE,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_real_3d_array_kind8

subroutine read_integer_kind4(x,name,id,got,error)
  integer(kind=4), intent(out) :: x
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  logical,         intent(out) :: got
  integer,         intent(out) :: error

  integer(HSIZE_T), parameter  :: xshape(0) = 0
  integer(HID_T) :: dset_id
  integer :: errors(3)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_INTEGER,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_integer_kind4

subroutine read_integer_1d_array_kind1(x,name,id,got,error)
  integer(kind=1), intent(out) :: x(:)
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  logical,         intent(out) :: got
  integer,         intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_STD_I8LE,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_integer_1d_array_kind1

subroutine read_integer_1d_array_kind4(x,name,id,got,error)
  integer(kind=4), intent(out) :: x(:)
  character(*),    intent(in)  :: name
  integer(HID_T),  intent(in)  :: id
  logical,         intent(out) :: got
  integer,         intent(out) :: error

  integer, parameter :: ndims = 1
  integer(HSIZE_T)   :: xshape(ndims)
  integer(HID_T)     :: dset_id
  integer :: errors(3)

  xshape = shape(x)

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  ! Open dataset
  call h5dopen_f(id,name,dset_id,errors(1))

  ! Read dataset
  call h5dread_f(dset_id,H5T_NATIVE_INTEGER,x,xshape,errors(2))

  ! Close dataset
  call h5dclose_f(dset_id,errors(3))

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_integer_1d_array_kind4

subroutine read_string(str,name,id,got,error)
  character(*),   intent(out) :: str
  character(*),   intent(in)  :: name
  integer(HID_T), intent(in)  :: id
  logical,        intent(out) :: got
  integer,        intent(out) :: error

  integer :: errors(12)

  integer,         parameter :: dim0 = 1
  integer(SIZE_T), parameter :: sdim = 100

  integer(HSIZE_T) :: dims(1) = (/dim0/)
  integer(HSIZE_T) :: maxdims(1)

  integer(HID_T) :: filetype,memtype,space,dset

  character(LEN=sdim), allocatable, target :: rdata(:)
  integer(SIZE_T) :: size
  type(c_ptr) :: f_ptr

  ! Check if dataset exists
  call h5lexists_f(id,name,got,error)
  if (.not.got) return

  call h5dopen_f(id,name,dset,errors(1))

  ! Get the datatype and its size.
  call h5dget_type_f(dset,filetype,errors(2))
  call h5tget_size_f(filetype,size,errors(3))

  ! Make sure the declared length is large enough,
  ! the C string contains the null character.
  if (size > sdim+1) then
    print*,'ERROR: Character LEN is too small'
    stop
  endif

  ! Get dataspace.
  call h5dget_space_f(dset,space,errors(4))
  call h5sget_simple_extent_dims_f(space,dims,maxdims,errors(5))

  allocate(rdata(1:dims(1)))

  ! Create the memory datatype.
  call H5Tcopy_f(H5T_FORTRAN_S1,memtype,errors(6))
  call H5Tset_size_f(memtype,sdim,errors(7))

  ! Read the data.
  f_ptr = C_LOC(rdata(1)(1:1))
  call H5Dread_f(dset,memtype,f_ptr,errors(8),space)

  ! Close and release resources.
  call H5Dclose_f(dset,errors(9))
  call H5Sclose_f(space,errors(10))
  call H5Tclose_f(filetype,errors(11))
  call H5Tclose_f(memtype,errors(12))

  str = rdata(1)

  deallocate(rdata)

  error = maxval(abs(errors))

  if (error /= 0) got = .false.

end subroutine read_string

end module hdf5utils
