module lib_utils_hdf5

  use utils_hdf5, only: write_real_kind4,             & ! real(4)
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
                        create_hdf5file,              &
                        open_hdf5file,                &
                        close_hdf5file,               &
                        create_hdf5group,             &
                        open_hdf5group,               &
                        close_hdf5group,              &
                        HID_T


  implicit none

  public :: write_to_hdf5,    &
            read_from_hdf5,   &
            open_hdf5file,    &
            create_hdf5file,  &
            close_hdf5file,   &
            open_hdf5group,   &
            create_hdf5group, &
            close_hdf5group,  &
            HID_T

  private

  interface write_to_hdf5
    module procedure write_real_kind4,              & ! real(4)
                     write_real_kind8,              & ! real(8)
                     write_real_1d_array_kind4,     & ! 1d real(4) arrays
                     write_real_1d_array_kind8,     & ! 1d real(8) arrays
                     write_real_2d_array_kind4,     & ! 2d real(4) arrays
                     write_real_2d_array_kind8,     & ! 2d real(8) arrays
                     write_real_3d_array_kind4,     & ! 3d real(4) arrays
                     write_real_3d_array_kind8,     & ! 3d real(8) arrays
                     write_integer_kind4,           & ! integer(4)
                     write_integer_1d_array_kind1,  & ! 1d integer(1) arrays
                     write_integer_1d_array_kind4,  & ! 1d integer(4) arrays
                     write_string                     ! strings
  end interface write_to_hdf5

  interface read_from_hdf5
    module procedure read_real_kind4,              & ! real(4)
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
                     read_string                     ! strings
  end interface read_from_hdf5

end module lib_utils_hdf5
