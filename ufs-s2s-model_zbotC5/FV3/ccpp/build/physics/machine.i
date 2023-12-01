# 1 "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics/physics/machine.F"
      module machine

!! \section arg_table_machine
!! \htmlinclude machine.html
!!

      implicit none
      

      integer, parameter :: kind_io4  = 4, kind_io8  = 8 , kind_ior = 8 
     &,                     kind_evod = 8, kind_dbl_prec = 8            
# 14

     &,                     kind_qdt_prec = 16                          

     &,                     kind_rad  = 8                               
     &,                     kind_phys = 8     ,kind_taum=8              
     &,                     kind_grid = 8                               
     &,                     kind_REAL = 8                               
     &,                     kind_LOGICAL = 4                            
     &,                     kind_INTEGER = 4                            

# 39


# 43

      integer, parameter :: kind_dyn  = 8


!
      real(kind=kind_evod), parameter :: mprec = 1.e-12           ! machine precision to restrict dep
      real(kind=kind_evod), parameter :: grib_undef = 9.99e20     ! grib undefine value
!
      end module machine
