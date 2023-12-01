
!
! This work (Common Community Physics Package), identified by NOAA, NCAR,
! CU/CIRES, is free of known copyright restrictions and is placed in the
! public domain.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
! THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
! IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
! CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!

!>
!! @brief Auto-generated cap module for the CCPP suite
!!
!
module ccpp_FV3_GFS_v15p2_coupled_cap

   use ccpp_FV3_GFS_v15p2_coupled_fast_physics_cap, only: FV3_GFS_v15p2_coupled_fast_physics_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_fast_physics_cap, only: FV3_GFS_v15p2_coupled_fast_physics_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_fast_physics_cap, only: FV3_GFS_v15p2_coupled_fast_physics_finalize_cap
   use ccpp_FV3_GFS_v15p2_coupled_time_vary_cap, only: FV3_GFS_v15p2_coupled_time_vary_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_time_vary_cap, only: FV3_GFS_v15p2_coupled_time_vary_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_time_vary_cap, only: FV3_GFS_v15p2_coupled_time_vary_finalize_cap
   use ccpp_FV3_GFS_v15p2_coupled_radiation_cap, only: FV3_GFS_v15p2_coupled_radiation_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_radiation_cap, only: FV3_GFS_v15p2_coupled_radiation_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_radiation_cap, only: FV3_GFS_v15p2_coupled_radiation_finalize_cap
   use ccpp_FV3_GFS_v15p2_coupled_physics_cap, only: FV3_GFS_v15p2_coupled_physics_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_physics_cap, only: FV3_GFS_v15p2_coupled_physics_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_physics_cap, only: FV3_GFS_v15p2_coupled_physics_finalize_cap
   use ccpp_FV3_GFS_v15p2_coupled_stochastics_cap, only: FV3_GFS_v15p2_coupled_stochastics_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_stochastics_cap, only: FV3_GFS_v15p2_coupled_stochastics_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_stochastics_cap, only: FV3_GFS_v15p2_coupled_stochastics_finalize_cap


   implicit none

   private
   public :: FV3_GFS_v15p2_coupled_init_cap, &
             FV3_GFS_v15p2_coupled_run_cap, &
             FV3_GFS_v15p2_coupled_finalize_cap

   contains

   function FV3_GFS_v15p2_coupled_init_cap(GFS_Data,GFS_Control,CCPP_interstitial,con_p0,GFS_Interstitial,cdata) result(ierr)

      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_control_type
      use CCPP_typedefs, only: CCPP_interstitial_type
      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t

      implicit none

      integer :: ierr
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      type(GFS_control_type), intent(inout) :: GFS_Control
      type(CCPP_interstitial_type), intent(in) :: CCPP_interstitial
      real(kind_phys), intent(in) :: con_p0
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      ierr = FV3_GFS_v15p2_coupled_fast_physics_init_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_radiation_init_cap()
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_stochastics_init_cap()
      if (ierr/=0) return


   end function FV3_GFS_v15p2_coupled_init_cap

   function FV3_GFS_v15p2_coupled_run_cap(con_sbc,con_t0c,con_rd,LTP,con_eps,con_hvap,con_cliq,GFS_Data,con_g,con_pi, &
                  cimin,con_epsm1,huge,GFS_Interstitial,con_cp,cdata,GFS_Control,con_cvap, &
                  CCPP_interstitial,con_rv,con_fvirt,con_tice) result(ierr)

      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_control_type
      use CCPP_typedefs, only: CCPP_interstitial_type

      implicit none

      integer :: ierr
      real(kind_phys), intent(in) :: con_sbc
      real(kind_phys), intent(in) :: con_t0c
      real(kind_phys), intent(in) :: con_rd
      integer, intent(in) :: LTP
      real(kind_phys), intent(in) :: con_eps
      real(kind_phys), intent(in) :: con_hvap
      real(kind_phys), intent(in) :: con_cliq
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      real(kind_phys), intent(in) :: con_g
      real(kind_phys), intent(in) :: con_pi
      real(kind_phys), intent(in) :: cimin
      real(kind_phys), intent(in) :: con_epsm1
      real(kind_phys), intent(in) :: huge
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      real(kind_phys), intent(in) :: con_cp
      type(ccpp_t), intent(inout) :: cdata
      type(GFS_control_type), intent(inout) :: GFS_Control
      real(kind_phys), intent(in) :: con_cvap
      type(CCPP_interstitial_type), intent(inout) :: CCPP_interstitial
      real(kind_phys), intent(in) :: con_rv
      real(kind_phys), intent(in) :: con_fvirt
      real(kind_phys), intent(in) :: con_tice

      ierr = 0


      ierr = FV3_GFS_v15p2_coupled_fast_physics_run_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_radiation_run_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Data=GFS_Data,GFS_Control=GFS_Control, &
                  LTP=LTP)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_physics_run_cap(con_sbc=con_sbc,con_pi=con_pi,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_cliq=con_cliq,con_epsm1=con_epsm1,con_hvap=con_hvap,GFS_Interstitial=GFS_Interstitial, &
                  con_rd=con_rd,con_cvap=con_cvap,con_rv=con_rv,con_g=con_g,con_cp=con_cp, &
                  huge=huge,con_t0c=con_t0c,con_fvirt=con_fvirt,con_tice=con_tice,cdata=cdata, &
                  con_eps=con_eps,cimin=cimin)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return


   end function FV3_GFS_v15p2_coupled_run_cap

   function FV3_GFS_v15p2_coupled_finalize_cap(cdata) result(ierr)

      use ccpp_types, only: ccpp_t

      implicit none

      integer :: ierr
      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      ierr = FV3_GFS_v15p2_coupled_fast_physics_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_time_vary_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_radiation_finalize_cap()
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_physics_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_v15p2_coupled_stochastics_finalize_cap()
      if (ierr/=0) return


   end function FV3_GFS_v15p2_coupled_finalize_cap

end module ccpp_FV3_GFS_v15p2_coupled_cap
