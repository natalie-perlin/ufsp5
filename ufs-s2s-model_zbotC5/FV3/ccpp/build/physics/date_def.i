# 1 "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics/physics/date_def.f"
      module date_def
      use machine,   ONLY: kind_evod
      implicit none
      
!jw      integer idate(4)
!jw      real(kind=kind_evod) fhour,shour,thour,z00
       real(kind=kind_evod) shour,thour,z00
       real(kind=kind_evod),target :: fhour, zhour
       integer,target :: idate(4),idate7(7)
!
      REAL(KIND=KIND_EVOD) ,ALLOCATABLE :: spdmax(:)

      end module date_def
