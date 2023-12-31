# 1 "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics/physics/iccn_def.F"
!>\file iccn_def.F
!! This file defines IN and CCN arrays.

!>\ingroup mod_GFS_phys_time_vary
!! This module defines IN and CCN arrays.
      module iccn_def
      use machine , only : kind_phys
      implicit none
      
      integer, parameter :: kcipl=32, latscip=192, lonscip=288
     &                      , timeci=12

      real (kind=kind_phys)::  ci_lat(latscip), ci_lon(lonscip)
     &                       , ci_time(timeci+1)
      real (kind=4), allocatable, dimension(:,:,:,:):: ciplin, ccnin
      real (kind=kind_phys), allocatable, dimension(:,:,:,:):: ci_pres
      data ci_time/15.5,45.,74.5,105.,135.5,166.,196.5,     
     &            227.5,258.,288.5,319.,349.5,380.5/

      end module iccn_def
