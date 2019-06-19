program prog
  use libhdf5utils, only: write_to_hdf5,    &
                          create_hdf5file,  &
                          close_hdf5file,   &
                          create_hdf5group, &
                          close_hdf5group,  &
                          HID_T

  implicit none

  character(len=100) :: filename
  real :: value
  integer :: error

  integer(HID_T) :: file_id, group_id

  error = 0
  filename = 'test.h5'
  value = 1234.

  call create_hdf5file(filename,file_id,error)
  call create_hdf5group(file_id,'header',group_id,error)
  call write_to_hdf5(value,'value',group_id,error)
  call close_hdf5group(group_id, error)
  call close_hdf5file(file_id,error)

end program prog
