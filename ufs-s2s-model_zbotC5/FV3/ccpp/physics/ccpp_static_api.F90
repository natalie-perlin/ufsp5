
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
!! @brief Auto-generated API for the CCPP static build
!!
!
module ccpp_static_api

   use ccpp_FV3_GFS_2017_coupled_cap, only: FV3_GFS_2017_coupled_init_cap
   use ccpp_FV3_GFS_2017_coupled_cap, only: FV3_GFS_2017_coupled_run_cap
   use ccpp_FV3_GFS_2017_coupled_cap, only: FV3_GFS_2017_coupled_finalize_cap
   use ccpp_FV3_GFS_2017_coupled_time_vary_cap, only: FV3_GFS_2017_coupled_time_vary_init_cap
   use ccpp_FV3_GFS_2017_coupled_time_vary_cap, only: FV3_GFS_2017_coupled_time_vary_run_cap
   use ccpp_FV3_GFS_2017_coupled_time_vary_cap, only: FV3_GFS_2017_coupled_time_vary_finalize_cap
   use ccpp_FV3_GFS_2017_coupled_radiation_cap, only: FV3_GFS_2017_coupled_radiation_init_cap
   use ccpp_FV3_GFS_2017_coupled_radiation_cap, only: FV3_GFS_2017_coupled_radiation_run_cap
   use ccpp_FV3_GFS_2017_coupled_radiation_cap, only: FV3_GFS_2017_coupled_radiation_finalize_cap
   use ccpp_FV3_GFS_2017_coupled_physics_cap, only: FV3_GFS_2017_coupled_physics_init_cap
   use ccpp_FV3_GFS_2017_coupled_physics_cap, only: FV3_GFS_2017_coupled_physics_run_cap
   use ccpp_FV3_GFS_2017_coupled_physics_cap, only: FV3_GFS_2017_coupled_physics_finalize_cap
   use ccpp_FV3_GFS_2017_coupled_stochastics_cap, only: FV3_GFS_2017_coupled_stochastics_init_cap
   use ccpp_FV3_GFS_2017_coupled_stochastics_cap, only: FV3_GFS_2017_coupled_stochastics_run_cap
   use ccpp_FV3_GFS_2017_coupled_stochastics_cap, only: FV3_GFS_2017_coupled_stochastics_finalize_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_cap, only: FV3_GFS_2017_satmedmf_coupled_init_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_cap, only: FV3_GFS_2017_satmedmf_coupled_run_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_cap, only: FV3_GFS_2017_satmedmf_coupled_finalize_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_time_vary_cap, only: FV3_GFS_2017_satmedmf_coupled_time_vary_init_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_time_vary_cap, only: FV3_GFS_2017_satmedmf_coupled_time_vary_run_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_time_vary_cap, only: FV3_GFS_2017_satmedmf_coupled_time_vary_finalize_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_radiation_cap, only: FV3_GFS_2017_satmedmf_coupled_radiation_init_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_radiation_cap, only: FV3_GFS_2017_satmedmf_coupled_radiation_run_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_radiation_cap, only: FV3_GFS_2017_satmedmf_coupled_radiation_finalize_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_physics_cap, only: FV3_GFS_2017_satmedmf_coupled_physics_init_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_physics_cap, only: FV3_GFS_2017_satmedmf_coupled_physics_run_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_physics_cap, only: FV3_GFS_2017_satmedmf_coupled_physics_finalize_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_stochastics_cap, only: FV3_GFS_2017_satmedmf_coupled_stochastics_init_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_stochastics_cap, only: FV3_GFS_2017_satmedmf_coupled_stochastics_run_cap
   use ccpp_FV3_GFS_2017_satmedmf_coupled_stochastics_cap, only: FV3_GFS_2017_satmedmf_coupled_stochastics_finalize_cap
   use ccpp_FV3_GFS_v15p2_coupled_cap, only: FV3_GFS_v15p2_coupled_init_cap
   use ccpp_FV3_GFS_v15p2_coupled_cap, only: FV3_GFS_v15p2_coupled_run_cap
   use ccpp_FV3_GFS_v15p2_coupled_cap, only: FV3_GFS_v15p2_coupled_finalize_cap
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
   use CCPP_data, only: GFS_Interstitial
   use CCPP_data, only: GFS_Control
   use CCPP_data, only: GFS_Data
   use GFS_typedefs, only: con_p0
   use CCPP_data, only: CCPP_interstitial
   use GFS_typedefs, only: cimin
   use GFS_typedefs, only: con_tice
   use GFS_typedefs, only: con_t0c
   use GFS_typedefs, only: huge
   use GFS_typedefs, only: con_epsm1
   use GFS_typedefs, only: con_cliq
   use GFS_typedefs, only: con_rd
   use GFS_typedefs, only: con_hvap
   use GFS_typedefs, only: con_rv
   use GFS_typedefs, only: con_g
   use GFS_typedefs, only: con_cp
   use GFS_typedefs, only: con_cvap
   use GFS_typedefs, only: LTP
   use GFS_typedefs, only: con_fvirt
   use GFS_typedefs, only: con_pi
   use GFS_typedefs, only: con_eps
   use GFS_typedefs, only: con_sbc
   use GFS_typedefs, only: con_hfus

   implicit none

   private
   public :: ccpp_physics_init,ccpp_physics_run,ccpp_physics_finalize

   contains

   subroutine ccpp_physics_init(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_coupled_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_coupled_radiation_init_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_coupled_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_coupled_stochastics_init_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_coupled_init_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_p0=con_p0)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_satmedmf_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_satmedmf_coupled_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_satmedmf_coupled_radiation_init_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_stochastics_init_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_satmedmf_coupled_init_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_p0=con_p0)

         end if

      else if (trim(suite_name)=="FV3_GFS_v15p2_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_v15p2_coupled_fast_physics_init_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_v15p2_coupled_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_v15p2_coupled_radiation_init_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_v15p2_coupled_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_v15p2_coupled_stochastics_init_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_v15p2_coupled_init_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,CCPP_interstitial=CCPP_interstitial, &
                  con_p0=con_p0,GFS_Interstitial=GFS_Interstitial,cdata=cdata)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_init

   subroutine ccpp_physics_run(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_coupled_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_coupled_radiation_run_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Data=GFS_Data,GFS_Control=GFS_Control, &
                  LTP=LTP)
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_coupled_physics_run_cap(con_sbc=con_sbc,con_pi=con_pi,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_cliq=con_cliq,con_epsm1=con_epsm1,con_hvap=con_hvap,GFS_Interstitial=GFS_Interstitial, &
                  con_rd=con_rd,con_cvap=con_cvap,con_rv=con_rv,con_g=con_g,con_cp=con_cp, &
                  huge=huge,con_t0c=con_t0c,con_fvirt=con_fvirt,con_tice=con_tice,cdata=cdata, &
                  con_eps=con_eps,cimin=cimin)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_coupled_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_coupled_run_cap(cimin=cimin,con_tice=con_tice,con_t0c=con_t0c,GFS_Data=GFS_Data,GFS_Control=GFS_Control, &
                  huge=huge,con_epsm1=con_epsm1,con_cliq=con_cliq,GFS_Interstitial=GFS_Interstitial, &
                  con_rd=con_rd,con_hvap=con_hvap,con_rv=con_rv,con_g=con_g,con_cp=con_cp, &
                  con_cvap=con_cvap,LTP=LTP,con_fvirt=con_fvirt,con_pi=con_pi,cdata=cdata, &
                  con_eps=con_eps,con_sbc=con_sbc)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_satmedmf_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_satmedmf_coupled_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_satmedmf_coupled_radiation_run_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Data=GFS_Data,GFS_Control=GFS_Control, &
                  LTP=LTP)
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_physics_run_cap(con_sbc=con_sbc,con_pi=con_pi,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_cliq=con_cliq,con_epsm1=con_epsm1,con_hvap=con_hvap,con_hfus=con_hfus, &
                  GFS_Interstitial=GFS_Interstitial,con_rd=con_rd,con_cvap=con_cvap,con_rv=con_rv, &
                  con_g=con_g,con_cp=con_cp,huge=huge,con_t0c=con_t0c,con_fvirt=con_fvirt, &
                  con_tice=con_tice,cdata=cdata,con_eps=con_eps,cimin=cimin)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_satmedmf_coupled_run_cap(con_sbc=con_sbc,con_t0c=con_t0c,con_rd=con_rd,LTP=LTP,con_eps=con_eps,con_hvap=con_hvap, &
                  con_cliq=con_cliq,GFS_Data=GFS_Data,con_g=con_g,con_pi=con_pi,cimin=cimin, &
                  con_epsm1=con_epsm1,GFS_Interstitial=GFS_Interstitial,huge=huge,con_hfus=con_hfus, &
                  con_cp=con_cp,cdata=cdata,GFS_Control=GFS_Control,con_cvap=con_cvap,con_rv=con_rv, &
                  con_fvirt=con_fvirt,con_tice=con_tice)

         end if

      else if (trim(suite_name)=="FV3_GFS_v15p2_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_v15p2_coupled_fast_physics_run_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_v15p2_coupled_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_v15p2_coupled_radiation_run_cap(cdata=cdata,GFS_Interstitial=GFS_Interstitial,GFS_Data=GFS_Data,GFS_Control=GFS_Control, &
                  LTP=LTP)
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_v15p2_coupled_physics_run_cap(con_sbc=con_sbc,con_pi=con_pi,GFS_Control=GFS_Control,GFS_Data=GFS_Data, &
                  con_cliq=con_cliq,con_epsm1=con_epsm1,con_hvap=con_hvap,GFS_Interstitial=GFS_Interstitial, &
                  con_rd=con_rd,con_cvap=con_cvap,con_rv=con_rv,con_g=con_g,con_cp=con_cp, &
                  huge=huge,con_t0c=con_t0c,con_fvirt=con_fvirt,con_tice=con_tice,cdata=cdata, &
                  con_eps=con_eps,cimin=cimin)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_v15p2_coupled_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_v15p2_coupled_run_cap(con_sbc=con_sbc,con_t0c=con_t0c,con_rd=con_rd,LTP=LTP,con_eps=con_eps,con_hvap=con_hvap, &
                  con_cliq=con_cliq,GFS_Data=GFS_Data,con_g=con_g,con_pi=con_pi,cimin=cimin, &
                  con_epsm1=con_epsm1,huge=huge,GFS_Interstitial=GFS_Interstitial,con_cp=con_cp, &
                  cdata=cdata,GFS_Control=GFS_Control,con_cvap=con_cvap,CCPP_interstitial=CCPP_interstitial, &
                  con_rv=con_rv,con_fvirt=con_fvirt,con_tice=con_tice)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_run

   subroutine ccpp_physics_finalize(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_coupled_time_vary_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_coupled_radiation_finalize_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_coupled_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_coupled_stochastics_finalize_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_coupled_finalize_cap(cdata=cdata)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_satmedmf_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_satmedmf_coupled_time_vary_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_satmedmf_coupled_radiation_finalize_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_satmedmf_coupled_stochastics_finalize_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_satmedmf_coupled_finalize_cap(cdata=cdata)

         end if

      else if (trim(suite_name)=="FV3_GFS_v15p2_coupled") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_v15p2_coupled_fast_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_v15p2_coupled_time_vary_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_v15p2_coupled_radiation_finalize_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_v15p2_coupled_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_v15p2_coupled_stochastics_finalize_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_v15p2_coupled_finalize_cap(cdata=cdata)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_finalize

end module ccpp_static_api
