# 1 "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics/physics/shalcnv.F"
!> \defgroup SASHAL Mass-Flux Shallow Convection
!! @{
!!  \brief The Mass-Flux shallow convection scheme parameterizes the effect of shallow convection on the environment much like the \ref SAS scheme with a few key modifications. Perhaps most importantly, no quasi-equilibrium assumption is necessary since the shallow cloud base mass flux is parameterized from the surface buoyancy flux. Further, there are no convective downdrafts, the entrainment rate is greater than for deep convection, and the shallow convection is limited to not extend over the level where \f$p=0.7p_{sfc}\f$.
!!
!!  This scheme was designed to replace the previous eddy-diffusivity approach to shallow convection with a mass-flux based approach as it is used for deep convection. Differences between the shallow and deep SAS schemes are presented in Han and Pan (2011) \cite han_and_pan_2011 . Like the deep scheme, it uses the working concepts put forth in Arakawa and Schubert (1974) \cite arakawa_and_schubert_1974 but includes modifications and simplifications from Grell (1993) \cite grell_1993 such as only one cloud type (the deepest possible, up to \f$p=0.7p_{sfc}\f$), rather than a spectrum based on cloud top heights or assumed entrainment rates, although it assumes no convective downdrafts. It contains many modifications associated with deep scheme as discussed in Han and Pan (2011) \cite han_and_pan_2011 , including the calculation of cloud top, a greater CFL-criterion-based maximum cloud base mass flux, and the inclusion of convective overshooting.
!!
!!  \section diagram Calling Hierarchy Diagram
!!  \image html Shallow_SAS_Flowchart.png "Diagram depicting how the SAS shallow convection scheme is called from the GSM physics time loop" height=2cm
!!  \section intraphysics Intraphysics Communication
!!  This space is reserved for a description of how this scheme uses information from other scheme types and/or how information calculated in this scheme is used in other scheme types.

!> \file shalcnv.F
!!  Contains the entire SAS shallow convection scheme.
      module shalcnv

      implicit none

      private

      public :: shalcnv_init, shalcnv_run, shalcnv_finalize

      contains

!!
!! \section arg_table_shalcnv_init Argument Table
!! \htmlinclude shalcnv_init.html
!!
      subroutine shalcnv_init(do_shoc,shal_cnv,imfshalcnv,              
     &                        imfshalcnv_sas,errmsg,errflg)
!
      logical,          intent(in)  :: do_shoc,shal_cnv
      integer,          intent(in)  :: imfshalcnv, imfshalcnv_sas
      character(len=*), intent(out) :: errmsg
      integer,          intent(out) :: errflg
!
!     initialize 1 error handling variables
      errmsg = ''
      errflg = 0
!
      if (do_shoc .or. .not.shal_cnv .or.                               
     &    imfshalcnv/=imfshalcnv_sas) then
        write(errmsg,'(*(a))') 'Logic error: shalcnv incompatible with',
     &                  ' control flags do_shoc, shal_cnv or imfshalcnv'
        errflg = 1
        return
      endif
!
      end subroutine shalcnv_init

! \brief This subroutine is empty since there are no procedures that need to be done to finalize the shalcnv code.
!!
!! \section arg_table_shalcnv_finalize Argument Table
!!
      subroutine shalcnv_finalize
      end subroutine shalcnv_finalize

!>  \brief This subroutine contains the entirety of the SAS shallow convection scheme.
!!
!!  This routine follows the \ref SAS scheme quite closely, although it can be interpreted as only having the "static" and "feedback" control portions, since the "dynamic" control is not necessary to find the cloud base mass flux. The algorithm is simplified from SAS deep convection by excluding convective downdrafts and being confined to operate below \f$p=0.7p_{sfc}\f$. Also, entrainment is both simpler and stronger in magnitude compared to the deep scheme.
!!
!!  \param[in] im horizontal dimension
!!  \param[in] km vertical layer dimension
!!  \param[in] jcap number of spectral wave trancation
!!  \param[in] delt physics time step in seconds
!!  \param[in] delp pressure difference between level k and k+1 (Pa)
!!  \param[in] prslp mean layer presure (Pa)
!!  \param[in] psp surface pressure (Pa)
!!  \param[in] phil layer geopotential (\f$m^2/s^2\f$)
!!  \param[inout] qlc cloud water (kg/kg)
!!  \param[inout] qli ice (kg/kg)
!!  \param[inout] q1 updated tracers (kg/kg)
!!  \param[inout] t1 updated temperature (K)
!!  \param[inout] u1 updated zonal wind (\f$m s^{-1}\f$)
!!  \param[inout] v1 updated meridional wind (\f$m s^{-1}\f$)
!!  \param[out] rn convective rain (m)
!!  \param[out] kbot index for cloud base
!!  \param[out] ktop index for cloud top
!!  \param[out] kcnv flag to denote deep convection (0=no, 1=yes)
!!  \param[in] islimsk sea/land/ice mask (=0/1/2)
!!  \param[in] dot layer mean vertical velocity (Pa/s)
!!  \param[in] ncloud number of cloud species
!!  \param[in] hpbl PBL height (m)
!!  \param[in] heat surface sensible heat flux (K m/s)
!!  \param[in] evap surface latent heat flux (kg/kg m/s)
!!  \param[out] ud_mf updraft mass flux multiplied by time step (\f$kg/m^2\f$)
!!  \param[out] dt_mf ud_mf at cloud top (\f$kg/m^2\f$)
!!  \param[out] cnvw convective cloud water (kg/kg)
!!  \param[out] cnvc convective cloud cover (unitless)
!!
!!  \section general General Algorithm
!!  -# Compute preliminary quantities needed for the static and feedback control portions of the algorithm.
!!  -# Perform calculations related to the updraft of the entraining/detraining cloud model ("static control").
!!  -# Calculate the tendencies of the state variables (per unit cloud base mass flux) and the cloud base mass flux.
!!  -# For the "feedback control", calculate updated values of the state variables by multiplying the cloud base mass flux and the tendencies calculated per unit cloud base mass flux from the static control.
!!  \section detailed Detailed Algorithm
!!
!! \section arg_table_shalcnv_run Argument Table
!! \htmlinclude shalcnv_run.html
!!
!!  @{
      subroutine shalcnv_run(                                           
     &     grav,cp,hvap,rv,fv,t0c,rd,cvap,cliq,eps,epsm1,               
     &     im,km,jcap,delt,delp,prslp,psp,phil,qlc,qli,                 
     &     q1,t1,u1,v1,rn,kbot,ktop,kcnv,islimsk,                       
     &     dot,ncloud,hpbl,heat,evap,ud_mf,dt_mf,cnvw,cnvc,             
     &     clam,c0,c1,pgcon,errmsg,errflg)
!
      use machine  , only : kind_phys
      use funcphys , only : fpvs
!      use physcons, grav => con_g, cp => con_cp, hvap => con_hvap       &
!     &,             rv => con_rv, fv => con_fvirt, t0c => con_t0c       &
!     &,             rd => con_rd, cvap => con_cvap, cliq => con_cliq    &
!     &,             eps => con_eps, epsm1 => con_epsm1
      implicit none
!
! Interface variables
!
      real(kind=kind_phys), intent(in) :: grav, cp, hvap, rv, fv, t0c,  
     &                                    rd, cvap, cliq, eps, epsm1
      integer,              intent(in) :: im, km, jcap, ncloud
      integer,              intent(inout) :: kbot(:), ktop(:), kcnv(:)
      integer,              intent(in) :: islimsk(:)
      real(kind=kind_phys), intent(in) :: delt, clam, c0, c1, pgcon
      real(kind=kind_phys), intent(in) :: psp(:),     delp(:,:),        
     &                                    prslp(:,:), dot(:,:),         
     &                                    phil(:,:),  hpbl(:),          
     &                                    heat(:),    evap(:)
      real(kind=kind_phys), intent(inout) ::                            
     &                                    qlc(:,:),   qli(:,:),         
     &                                    q1(:,:),    t1(:,:),          
     &                                    u1(:,:),    v1(:,:),          
     &                                    cnvw(:,:),  cnvc(:,:)
      real(kind=kind_phys), intent(out) :: rn(:), ud_mf(:,:), dt_mf(:,:)
      character(len=*),     intent(out) :: errmsg
      integer,              intent(out) :: errflg
!
! Local variables
!
      integer              i,j,indx, k, kk, km1
      integer              kpbl(im)
!
      real(kind=kind_phys) dellat,  delta,
     &                     desdt,
     &                     dp,
     &                     dq,      dqsdp,   dqsdt,   dt,
     &                     dt2,     dtmax,   dtmin,   dv1h,
     &                     dv1q,    dv2h,    dv2q,    dv1u,
     &                     dv1v,    dv2u,    dv2v,    dv3q,
     &                     dv3h,    dv3u,    dv3v,
     &                     dz,      dz1,     e1,
     &                     el2orc,  elocp,   aafac,
     &                     es,      etah,    h1,      dthk,
     &                     evef,    evfact,  evfactl, fact1,
     &                     fact2,   factor,  fjcap,
     &                     g,       gamma,   pprime,  betaw,
     &                     qlk,     qrch,    qs,
     &                     rfact,   shear,   tem1,
     &                     val,     val1,
     &                     val2,    w1,      w1l,     w1s,
     &                     w2,      w2l,     w2s,     w3,
     &                     w3l,     w3s,     w4,      w4l,
     &                     w4s,     tem,     ptem,    ptem1
!
      integer              kb(im), kbcon(im), kbcon1(im),
     &                     ktcon(im), ktcon1(im),
     &                     kbm(im), kmax(im)
!
      real(kind=kind_phys) aa1(im),
     &                     delhbar(im), delq(im),   delq2(im),
     &                     delqbar(im), delqev(im), deltbar(im),
     &                     deltv(im),   edt(im),
     &                     wstar(im),   sflx(im),
     &                     pdot(im),    po(im,km),
     &                     qcond(im),   qevap(im),  hmax(im),
     &                     rntot(im),   vshear(im),
     &                     xlamud(im),  xmb(im),    xmbmax(im),
     &                     delubar(im), delvbar(im),
     &                     ps(im),      del(im,km), prsl(im,km)
!
      real(kind=kind_phys) cincr, cincrmax, cincrmin
!
!  physical parameters
!      parameter(g=grav)
!      parameter(elocp=hvap/cp,
!     &          el2orc=hvap*hvap/(rv*cp))
!      parameter(c0=.002,c1=5.e-4,delta=fv)
!      parameter(delta=fv)
!      parameter(fact1=(cvap-cliq)/rv,fact2=hvap/rv-fact1*t0c)
      parameter(cincrmax=180.,cincrmin=120.,dthk=25.)
      parameter(h1=0.33333333)
!  local variables and arrays
      real(kind=kind_phys) pfld(im,km),    to(im,km),     qo(im,km),
     &                     uo(im,km),      vo(im,km),     qeso(im,km)
!  cloud water
!     real(kind=kind_phys) qlko_ktcon(im), dellal(im,km), tvo(im,km),
      real(kind=kind_phys) qlko_ktcon(im), dellal(im,km),
     &                     dbyo(im,km),    zo(im,km),     xlamue(im,km),
     &                     heo(im,km),     heso(im,km),
     &                     dellah(im,km),  dellaq(im,km),
     &                     dellau(im,km),  dellav(im,km), hcko(im,km),
     &                     ucko(im,km),    vcko(im,km),   qcko(im,km),
     &                     qrcko(im,km),   eta(im,km),
     &                     zi(im,km),      pwo(im,km),
     &                     tx1(im),        cnvwt(im,km)
!
      logical totflg, cnvflg(im), flg(im)
!
      real(kind=kind_phys) tf, tcr, tcrf
      parameter (tf=233.16, tcr=263.16, tcrf=1.0/(tcr-tf))
!
!-----------------------------------------------------------------------
!
!************************************************************************
!     replace (derived) constants above with regular variables
      g      = grav
      elocp  = hvap/cp
      el2orc = hvap*hvap/(rv*cp)
      delta  = fv
      fact1  = (cvap-cliq)/rv
      fact2  = hvap/rv-fact1*t0c
!************************************************************************
!     initialize 1 error handling variables
      errmsg = ''
      errflg = 0
!************************************************************************
!     convert input pa terms to cb terms  -- moorthi
!>  ## Compute preliminary quantities needed for the static and feedback control portions of the algorithm.
!>  - Convert input pressure terms to centibar units.
      ps   = psp   * 0.001
      prsl = prslp * 0.001
      del  = delp  * 0.001
!************************************************************************
!
      km1 = km - 1
!
!  compute surface buoyancy flux
!
!>  - Compute the surface buoyancy flux according to
!! \f[
!! \overline{w'\theta_v'}=\overline{w'\theta'}+\left(\frac{R_v}{R_d}-1\right)T_0\overline{w'q'}
!! \f]
!! where \f$\overline{w'\theta'}\f$ is the surface sensible heat flux, \f$\overline{w'q'}\f$ is the surface latent heat flux, \f$R_v\f$ is the gas constant for water vapor, \f$R_d\f$ is the gas constant for dry air, and \f$T_0\f$ is a reference temperature.
      do i=1,im
        sflx(i) = heat(i)+fv*t1(i,1)*evap(i)
      enddo
!
!  initialize arrays
!
!>  - Initialize column-integrated and other single-value-per-column variable arrays.
      do i=1,im
        cnvflg(i) = .true.
        if(kcnv(i).eq.1) cnvflg(i) = .false.
        if(sflx(i).le.0.) cnvflg(i) = .false.
        if(cnvflg(i)) then
          kbot(i)=km+1
          ktop(i)=0
        endif
        rn(i)=0.
        kbcon(i)=km
        ktcon(i)=1
        kb(i)=km
        pdot(i) = 0.
        qlko_ktcon(i) = 0.
        edt(i)  = 0.
        aa1(i)  = 0.
        vshear(i) = 0.
      enddo
!>  - Initialize updraft and detrainment mass fluxes to zero.
! hchuang code change
      do k = 1, km
        do i = 1, im
          ud_mf(i,k) = 0.
          dt_mf(i,k) = 0.
        enddo
      enddo
!!
!>  - Return to the calling routine if deep convection is present or the surface buoyancy flux is negative.
      totflg = .true.
      do i=1,im
        totflg = totflg .and. (.not. cnvflg(i))
      enddo
      if(totflg) return
!!
!
!>  - Define tunable parameters.
      dt2   = delt
      val   =         1200.
      dtmin = max(dt2, val )
      val   =         3600.
      dtmax = max(dt2, val )
!  model tunable parameters are all here
!      clam    = .3
      aafac   = .1
      betaw   = .03
!     evef    = 0.07
      evfact  = 0.3
      evfactl = 0.3
!
!     pgcon   = 0.7     ! gregory et al. (1997, qjrms)
!      pgcon   = 0.55    ! zhang & wu (2003,jas)
      fjcap   = (float(jcap) / 126.) ** 2
      val     =           1.
      fjcap   = max(fjcap,val)
      w1l     = -8.e-3
      w2l     = -4.e-2
      w3l     = -5.e-3
      w4l     = -5.e-4
      w1s     = -2.e-4
      w2s     = -2.e-3
      w3s     = -1.e-3
      w4s     = -2.e-5
!
!  define top layer for search of the downdraft originating layer
!  and the maximum thetae for updraft
!
!>  - Determine maximum indices for the parcel starting point (kbm) and cloud top (kmax).
      do i=1,im
        kbm(i)   = km
        kmax(i)  = km
        tx1(i)   = 1.0 / ps(i)
      enddo
!
      do k = 1, km
        do i=1,im
          if (prsl(i,k)*tx1(i) .gt. 0.70) kbm(i)   = k + 1
          if (prsl(i,k)*tx1(i) .gt. 0.60) kmax(i)  = k + 1
        enddo
      enddo
      do i=1,im
        kbm(i)   = min(kbm(i),kmax(i))
      enddo
!
!  hydrostatic height assume zero terr and compute
!  updraft entrainment rate as an inverse function of height
!
!>  - Calculate hydrostatic height at layer centers assuming a flat surface (no terrain) from the geopotential.
      do k = 1, km
        do i=1,im
          zo(i,k) = phil(i,k) / g
        enddo
      enddo
!>  - Calculate interface height and the entrainment rate as an inverse function of height.
      do k = 1, km1
        do i=1,im
          zi(i,k) = 0.5*(zo(i,k)+zo(i,k+1))
          xlamue(i,k) = clam / zi(i,k)
        enddo
      enddo
      do i=1,im
        xlamue(i,km) = xlamue(i,km1)
      enddo
!
!  pbl height
!
!>  - Find the index for the PBL top using the PBL height; enforce that it is lower than the maximum parcel starting level.
      do i=1,im
        flg(i) = cnvflg(i)
        kpbl(i)= 1
      enddo
      do k = 2, km1
        do i=1,im
          if (flg(i).and.zo(i,k).le.hpbl(i)) then
            kpbl(i) = k
          else
            flg(i) = .false.
          endif
        enddo
      enddo
      do i=1,im
        kpbl(i)= min(kpbl(i),kbm(i))
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   convert surface pressure to mb from cb
!
!>  - Convert prsl from centibar to millibar, set normalized mass flux to 1, cloud properties to 0, and save model state variables (after advection/turbulence).
      do k = 1, km
        do i = 1, im
          if (cnvflg(i) .and. k .le. kmax(i)) then
            pfld(i,k) = prsl(i,k) * 10.0
            eta(i,k)  = 1.
            hcko(i,k) = 0.
            qcko(i,k) = 0.
            qrcko(i,k)= 0.
            ucko(i,k) = 0.
            vcko(i,k) = 0.
            dbyo(i,k) = 0.
            pwo(i,k)  = 0.
            dellal(i,k) = 0.
            to(i,k)   = t1(i,k)
            qo(i,k)   = q1(i,k)
            uo(i,k)   = u1(i,k)
            vo(i,k)   = v1(i,k)
!           uo(i,k)   = u1(i,k) * rcs(i)
!           vo(i,k)   = v1(i,k) * rcs(i)
            cnvwt(i,k) = 0.
          endif
        enddo
      enddo
!
!  column variables
!  p is pressure of the layer (mb)
!  t is temperature at t-dt (k)..tn
!  q is mixing ratio at t-dt (kg/kg)..qn
!  to is temperature at t+dt (k)... this is after advection and turbulan
!  qo is mixing ratio at t+dt (kg/kg)..q1
!
!>  - Calculate saturation mixing ratio and enforce minimum moisture values.
      do k = 1, km
        do i=1,im
          if (cnvflg(i) .and. k .le. kmax(i)) then
            qeso(i,k) = 0.01 * fpvs(to(i,k))      ! fpvs is in pa
            qeso(i,k) = eps * qeso(i,k) / (pfld(i,k) + epsm1*qeso(i,k))
            val1      =             1.e-8
            qeso(i,k) = max(qeso(i,k), val1)
            val2      =           1.e-10
            qo(i,k)   = max(qo(i,k), val2 )
!           qo(i,k)   = min(qo(i,k),qeso(i,k))
!           tvo(i,k)  = to(i,k) + delta * to(i,k) * qo(i,k)
          endif
        enddo
      enddo
!
!  compute moist static energy
!
!>  - Calculate moist static energy (heo) and saturation moist static energy (heso).
      do k = 1, km
        do i=1,im
          if (cnvflg(i) .and. k .le. kmax(i)) then
!           tem       = g * zo(i,k) + cp * to(i,k)
            tem       = phil(i,k) + cp * to(i,k)
            heo(i,k)  = tem  + hvap * qo(i,k)
            heso(i,k) = tem  + hvap * qeso(i,k)
!           heo(i,k)  = min(heo(i,k),heso(i,k))
          endif
        enddo
      enddo
!
!  determine level with largest moist static energy within pbl
!  this is the level where updraft starts
!
!> ## Perform calculations related to the updraft of the entraining/detraining cloud model ("static control").
!> - Search in the PBL for the level of maximum moist static energy to start the ascending parcel.
      do i=1,im
         if (cnvflg(i)) then
            hmax(i) = heo(i,1)
            kb(i) = 1
         endif
      enddo
      do k = 2, km
        do i=1,im
          if (cnvflg(i).and.k.le.kpbl(i)) then
            if(heo(i,k).gt.hmax(i)) then
              kb(i)   = k
              hmax(i) = heo(i,k)
            endif
          endif
        enddo
      enddo
!
!> - Calculate the temperature, water vapor mixing ratio, and pressure at interface levels.
      do k = 1, km1
        do i=1,im
          if (cnvflg(i) .and. k .le. kmax(i)-1) then
            dz      = .5 * (zo(i,k+1) - zo(i,k))
            dp      = .5 * (pfld(i,k+1) - pfld(i,k))
            es      = 0.01 * fpvs(to(i,k+1))      ! fpvs is in pa
            pprime  = pfld(i,k+1) + epsm1 * es
            qs      = eps * es / pprime
            dqsdp   = - qs / pprime
            desdt   = es * (fact1 / to(i,k+1) + fact2 / (to(i,k+1)**2))
            dqsdt   = qs * pfld(i,k+1) * desdt / (es * pprime)
            gamma   = el2orc * qeso(i,k+1) / (to(i,k+1)**2)
            dt      = (g * dz + hvap * dqsdp * dp) / (cp * (1. + gamma))
            dq      = dqsdt * dt + dqsdp * dp
            to(i,k) = to(i,k+1) + dt
            qo(i,k) = qo(i,k+1) + dq
            po(i,k) = .5 * (pfld(i,k) + pfld(i,k+1))
          endif
        enddo
      enddo
!
!> - Recalculate saturation mixing ratio, moist static energy, saturation moist static energy, and horizontal momentum on interface levels. Enforce minimum mixing ratios.
      do k = 1, km1
        do i=1,im
          if (cnvflg(i) .and. k .le. kmax(i)-1) then
            qeso(i,k) = 0.01 * fpvs(to(i,k))      ! fpvs is in pa
            qeso(i,k) = eps * qeso(i,k) / (po(i,k) + epsm1*qeso(i,k))
            val1      =             1.e-8
            qeso(i,k) = max(qeso(i,k), val1)
            val2      =           1.e-10
            qo(i,k)   = max(qo(i,k), val2 )
!           qo(i,k)   = min(qo(i,k),qeso(i,k))
            heo(i,k)  = .5 * g * (zo(i,k) + zo(i,k+1)) +
     &                  cp * to(i,k) + hvap * qo(i,k)
            heso(i,k) = .5 * g * (zo(i,k) + zo(i,k+1)) +
     &                  cp * to(i,k) + hvap * qeso(i,k)
            uo(i,k)   = .5 * (uo(i,k) + uo(i,k+1))
            vo(i,k)   = .5 * (vo(i,k) + vo(i,k+1))
          endif
        enddo
      enddo
!
!  look for the level of free convection as cloud base
!!> - Search below the index "kbm" for the level of free convection (LFC) where the condition \f$h_b > h^*\f$ is first met, where \f$h_b, h^*\f$ are the state moist static energy at the parcel's starting level and saturation moist static energy, respectively. Set "kbcon" to the index of the LFC.
      do i=1,im
        flg(i)   = cnvflg(i)
        if(flg(i)) kbcon(i) = kmax(i)
      enddo
      do k = 2, km1
        do i=1,im
          if (flg(i).and.k.lt.kbm(i)) then
            if(k.gt.kb(i).and.heo(i,kb(i)).gt.heso(i,k)) then
              kbcon(i) = k
              flg(i)   = .false.
            endif
          endif
        enddo
      enddo
!
!> - If no LFC, return to the calling routine without modifying state variables.
      do i=1,im
        if(cnvflg(i)) then
          if(kbcon(i).eq.kmax(i)) cnvflg(i) = .false.
        endif
      enddo
!!
      totflg = .true.
      do i=1,im
        totflg = totflg .and. (.not. cnvflg(i))
      enddo
      if(totflg) return
!!
!
!  determine critical convective inhibition
!  as a function of vertical velocity at cloud base.
!
!> - Determine the vertical pressure velocity at the LFC. After Han and Pan (2011) \cite han_and_pan_2011 , determine the maximum pressure thickness between a parcel's starting level and the LFC. If a parcel doesn't reach the LFC within the critical thickness, then the convective inhibition is deemed too great for convection to be triggered, and the subroutine returns to the calling routine without modifying the state variables.
      do i=1,im
        if(cnvflg(i)) then
!         pdot(i)  = 10.* dot(i,kbcon(i))
          pdot(i)  = 0.01 * dot(i,kbcon(i)) ! now dot is in pa/s
        endif
      enddo
      do i=1,im
        if(cnvflg(i)) then
          if(islimsk(i) == 1) then
            w1 = w1l
            w2 = w2l
            w3 = w3l
            w4 = w4l
          else
            w1 = w1s
            w2 = w2s
            w3 = w3s
            w4 = w4s
          endif
          if(pdot(i).le.w4) then
            ptem = (pdot(i) - w4) / (w3 - w4)
          elseif(pdot(i).ge.-w4) then
            ptem = - (pdot(i) + w4) / (w4 - w3)
          else
            ptem = 0.
          endif
          val1    =             -1.
          ptem = max(ptem,val1)
          val2    =             1.
          ptem = min(ptem,val2)
          ptem = 1. - ptem
          ptem1= .5*(cincrmax-cincrmin)
          cincr = cincrmax - ptem * ptem1
          tem1 = pfld(i,kb(i)) - pfld(i,kbcon(i))
          if(tem1.gt.cincr) then
             cnvflg(i) = .false.
          endif
        endif
      enddo
!!
      totflg = .true.
      do i=1,im
        totflg = totflg .and. (.not. cnvflg(i))
      enddo
      if(totflg) return
!!
!
!  assume the detrainment rate for the updrafts to be same as
!  the entrainment rate at cloud base
!
!> - The updraft detrainment rate is set constant and equal to the entrainment rate at cloud base.
      do i = 1, im
        if(cnvflg(i)) then
          xlamud(i) = xlamue(i,kbcon(i))
        endif
      enddo
!
!  determine updraft mass flux for the subcloud layers
!
!> - Calculate the normalized mass flux for subcloud and in-cloud layers according to Pan and Wu (1995) \cite pan_and_wu_1995 equation 1:
!!  \f[
!!  \frac{1}{\eta}\frac{\partial \eta}{\partial z} = \lambda_e - \lambda_d
!!  \f]
!!  where \f$\eta\f$ is the normalized mass flux, \f$\lambda_e\f$ is the entrainment rate and \f$\lambda_d\f$ is the detrainment rate. The normalized mass flux increases upward below the cloud base and decreases upward above.
      do k = km1, 1, -1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.lt.kbcon(i).and.k.ge.kb(i)) then
              dz       = zi(i,k+1) - zi(i,k)
              ptem     = 0.5*(xlamue(i,k)+xlamue(i,k+1))-xlamud(i)
              eta(i,k) = eta(i,k+1) / (1. + ptem * dz)
            endif
          endif
        enddo
      enddo
!
!  compute mass flux above cloud base
!
      do k = 2, km1
        do i = 1, im
         if(cnvflg(i))then
           if(k.gt.kbcon(i).and.k.lt.kmax(i)) then
              dz       = zi(i,k) - zi(i,k-1)
              ptem     = 0.5*(xlamue(i,k)+xlamue(i,k-1))-xlamud(i)
              eta(i,k) = eta(i,k-1) * (1 + ptem * dz)
           endif
         endif
        enddo
      enddo
!
!  compute updraft cloud property
!
!> - Set initial cloud properties equal to the state variables at cloud base.
      do i = 1, im
        if(cnvflg(i)) then
          indx         = kb(i)
          hcko(i,indx) = heo(i,indx)
          ucko(i,indx) = uo(i,indx)
          vcko(i,indx) = vo(i,indx)
        endif
      enddo
!
!> - Calculate the cloud properties as a parcel ascends, modified by entrainment and detrainment. Discretization follows Appendix B of Grell (1993) \cite grell_1993 . Following Han and Pan (2006) \cite han_and_pan_2006, the convective momentum transport is reduced by the convection-induced pressure gradient force by the constant "pgcon", currently set to 0.55 after Zhang and Wu (2003) \cite zhang_and_wu_2003 .
      do k = 2, km1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.lt.kmax(i)) then
              dz   = zi(i,k) - zi(i,k-1)
              tem  = 0.5 * (xlamue(i,k)+xlamue(i,k-1)) * dz
              tem1 = 0.5 * xlamud(i) * dz
              factor = 1. + tem - tem1
              ptem = 0.5 * tem + pgcon
              ptem1= 0.5 * tem - pgcon
              hcko(i,k) = ((1.-tem1)*hcko(i,k-1)+tem*0.5*
     &                     (heo(i,k)+heo(i,k-1)))/factor
              ucko(i,k) = ((1.-tem1)*ucko(i,k-1)+ptem*uo(i,k)
     &                     +ptem1*uo(i,k-1))/factor
              vcko(i,k) = ((1.-tem1)*vcko(i,k-1)+ptem*vo(i,k)
     &                     +ptem1*vo(i,k-1))/factor
              dbyo(i,k) = hcko(i,k) - heso(i,k)
            endif
          endif
        enddo
      enddo
!
!   taking account into convection inhibition due to existence of
!    dry layers below cloud base
!
!> - With entrainment, recalculate the LFC as the first level where buoyancy is positive. The difference in pressure levels between LFCs calculated with/without entrainment must be less than a threshold (currently 25 hPa). Otherwise, convection is inhibited and the scheme returns to the calling routine without modifying the state variables. This is the subcloud dryness trigger modification discussed in Han and Pan (2011) \cite han_and_pan_2011.
      do i=1,im
        flg(i) = cnvflg(i)
        kbcon1(i) = kmax(i)
      enddo
      do k = 2, km1
      do i=1,im
        if (flg(i).and.k.lt.kbm(i)) then
          if(k.ge.kbcon(i).and.dbyo(i,k).gt.0.) then
            kbcon1(i) = k
            flg(i)    = .false.
          endif
        endif
      enddo
      enddo
      do i=1,im
        if(cnvflg(i)) then
          if(kbcon1(i).eq.kmax(i)) cnvflg(i) = .false.
        endif
      enddo
      do i=1,im
        if(cnvflg(i)) then
          tem = pfld(i,kbcon(i)) - pfld(i,kbcon1(i))
          if(tem.gt.dthk) then
             cnvflg(i) = .false.
          endif
        endif
      enddo
!!
      totflg = .true.
      do i = 1, im
        totflg = totflg .and. (.not. cnvflg(i))
      enddo
      if(totflg) return
!!
!
!  determine first guess cloud top as the level of zero buoyancy
!    limited to the level of sigma=0.7
!
!> - Calculate the cloud top as the first level where parcel buoyancy becomes negative; the maximum possible value is at \f$p=0.7p_{sfc}\f$.
      do i = 1, im
        flg(i) = cnvflg(i)
        if(flg(i)) ktcon(i) = kbm(i)
      enddo
      do k = 2, km1
      do i=1,im
        if (flg(i).and.k .lt. kbm(i)) then
          if(k.gt.kbcon1(i).and.dbyo(i,k).lt.0.) then
             ktcon(i) = k
             flg(i)   = .false.
          endif
        endif
      enddo
      enddo
!
!  turn off shallow convection if cloud top is less than pbl top
!
!     do i=1,im
!       if(cnvflg(i)) then
!         kk = kpbl(i)+1
!         if(ktcon(i).le.kk) cnvflg(i) = .false.
!       endif
!     enddo
!!
!     totflg = .true.
!     do i = 1, im
!       totflg = totflg .and. (.not. cnvflg(i))
!     enddo
!     if(totflg) return
!!
!
!  specify upper limit of mass flux at cloud base
!
!> - Calculate the maximum value of the cloud base mass flux using the CFL-criterion-based formula of Han and Pan (2011) \cite han_and_pan_2011, equation 7.
      do i = 1, im
        if(cnvflg(i)) then
!         xmbmax(i) = .1
!
          k = kbcon(i)
          dp = 1000. * del(i,k)
          xmbmax(i) = dp / (g * dt2)
!
!         tem = dp / (g * dt2)
!         xmbmax(i) = min(tem, xmbmax(i))
        endif
      enddo
!
!  compute cloud moisture property and precipitation
!
!> - Initialize the cloud moisture at cloud base and set the cloud work function to zero.
      do i = 1, im
        if (cnvflg(i)) then
          aa1(i) = 0.
          qcko(i,kb(i)) = qo(i,kb(i))
          qrcko(i,kb(i)) = qo(i,kb(i))
        endif
      enddo
!> - Calculate the moisture content of the entraining/detraining parcel (qcko) and the value it would have if just saturated (qrch), according to equation A.14 in Grell (1993) \cite grell_1993 . Their difference is the amount of convective cloud water (qlk = rain + condensate). Determine the portion of convective cloud water that remains suspended and the portion that is converted into convective precipitation (pwo). Calculate and save the negative cloud work function (aa1) due to water loading. Above the level of minimum moist static energy, some of the cloud water is detrained into the grid-scale cloud water from every cloud layer with a rate of 0.0005 \f$m^{-1}\f$ (dellal).
      do k = 2, km1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.lt.ktcon(i)) then
              dz    = zi(i,k) - zi(i,k-1)
              gamma = el2orc * qeso(i,k) / (to(i,k)**2)
              qrch = qeso(i,k)
     &             + gamma * dbyo(i,k) / (hvap * (1. + gamma))
!j
              tem  = 0.5 * (xlamue(i,k)+xlamue(i,k-1)) * dz
              tem1 = 0.5 * xlamud(i) * dz
              factor = 1. + tem - tem1
              qcko(i,k) = ((1.-tem1)*qcko(i,k-1)+tem*0.5*
     &                     (qo(i,k)+qo(i,k-1)))/factor
              qrcko(i,k) = qcko(i,k)
!j
              dq = eta(i,k) * (qcko(i,k) - qrch)
!
!             rhbar(i) = rhbar(i) + qo(i,k) / qeso(i,k)
!
!  below lfc check if there is excess moisture to release latent heat
!
              if(k.ge.kbcon(i).and.dq.gt.0.) then
                etah = .5 * (eta(i,k) + eta(i,k-1))
                if(ncloud.gt.0.) then
                  dp = 1000. * del(i,k)
                  qlk = dq / (eta(i,k) + etah * (c0 + c1) * dz)
                  dellal(i,k) = etah * c1 * dz * qlk * g / dp
                else
                  qlk = dq / (eta(i,k) + etah * c0 * dz)
                endif
                aa1(i) = aa1(i) - dz * g * qlk
                qcko(i,k)= qlk + qrch
                pwo(i,k) = etah * c0 * dz * qlk
                cnvwt(i,k) = etah * qlk * g / dp
              endif
            endif
          endif
        enddo
      enddo
!
!  calculate cloud work function
!
!> - Calculate the cloud work function according to Pan and Wu (1995) \cite pan_and_wu_1995 equation 4:
!!  \f[
!!  A_u=\int_{z_0}^{z_t}\frac{g}{c_pT(z)}\frac{\eta}{1 + \gamma}[h(z)-h^*(z)]dz
!!  \f]
!! (discretized according to Grell (1993) \cite grell_1993 equation B.10 using B.2 and B.3 of Arakawa and Schubert (1974) \cite arakawa_and_schubert_1974 and assuming \f$\eta=1\f$) where \f$A_u\f$ is the updraft cloud work function, \f$z_0\f$ and \f$z_t\f$ are cloud base and cloud top, respectively, \f$\gamma = \frac{L}{c_p}\left(\frac{\partial \overline{q_s}}{\partial T}\right)_p\f$ and other quantities are previously defined.
      do k = 2, km1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.ge.kbcon(i).and.k.lt.ktcon(i)) then
              dz1 = zo(i,k+1) - zo(i,k)
              gamma = el2orc * qeso(i,k) / (to(i,k)**2)
              rfact =  1. + delta * cp * gamma
     &                 * to(i,k) / hvap
              aa1(i) = aa1(i) +
     &                 dz1 * (g / (cp * to(i,k)))
     &                 * dbyo(i,k) / (1. + gamma)
     &                 * rfact
              val = 0.
              aa1(i)=aa1(i)+
     &                 dz1 * g * delta *
     &                 max(val,(qeso(i,k) - qo(i,k)))
            endif
          endif
        enddo
      enddo
!> - If the updraft cloud work function is negative, convection does not occur, and the scheme returns to the calling routine.
      do i = 1, im
        if(cnvflg(i).and.aa1(i).le.0.) cnvflg(i) = .false.
      enddo
!!
      totflg = .true.
      do i=1,im
        totflg = totflg .and. (.not. cnvflg(i))
      enddo
      if(totflg) return
!!
!
!  estimate the onvective overshooting as the level
!    where the [aafac * cloud work function] becomes zero,
!    which is the final cloud top
!    limited to the level of sigma=0.7
!
!> - Continue calculating the cloud work function past the point of neutral buoyancy to represent overshooting according to Han and Pan (2011) \cite han_and_pan_2011 . Convective overshooting stops when \f$ cA_u < 0\f$ where \f$c\f$ is currently 10%, or when 10% of the updraft cloud work function has been consumed by the stable buoyancy force. Overshooting is also limited to the level where \f$p=0.7p_{sfc}\f$.
      do i = 1, im
        if (cnvflg(i)) then
          aa1(i) = aafac * aa1(i)
        endif
      enddo
!
      do i = 1, im
        flg(i) = cnvflg(i)
        ktcon1(i) = kbm(i)
      enddo
      do k = 2, km1
        do i = 1, im
          if (flg(i)) then
            if(k.ge.ktcon(i).and.k.lt.kbm(i)) then
              dz1 = zo(i,k+1) - zo(i,k)
              gamma = el2orc * qeso(i,k) / (to(i,k)**2)
              rfact =  1. + delta * cp * gamma
     &                 * to(i,k) / hvap
              aa1(i) = aa1(i) +
     &                 dz1 * (g / (cp * to(i,k)))
     &                 * dbyo(i,k) / (1. + gamma)
     &                 * rfact
              if(aa1(i).lt.0.) then
                ktcon1(i) = k
                flg(i) = .false.
              endif
            endif
          endif
        enddo
      enddo
!
!  compute cloud moisture property, detraining cloud water
!    and precipitation in overshooting layers
!
!> - For the overshooting convection, calculate the moisture content of the entraining/detraining parcel as before. Partition convective cloud water and precipitation and detrain convective cloud water in the overshooting layers.
      do k = 2, km1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.ge.ktcon(i).and.k.lt.ktcon1(i)) then
              dz    = zi(i,k) - zi(i,k-1)
              gamma = el2orc * qeso(i,k) / (to(i,k)**2)
              qrch = qeso(i,k)
     &             + gamma * dbyo(i,k) / (hvap * (1. + gamma))
!j
              tem  = 0.5 * (xlamue(i,k)+xlamue(i,k-1)) * dz
              tem1 = 0.5 * xlamud(i) * dz
              factor = 1. + tem - tem1
              qcko(i,k) = ((1.-tem1)*qcko(i,k-1)+tem*0.5*
     &                     (qo(i,k)+qo(i,k-1)))/factor
              qrcko(i,k) = qcko(i,k)
!j
              dq = eta(i,k) * (qcko(i,k) - qrch)
!
!  check if there is excess moisture to release latent heat
!
              if(dq.gt.0.) then
                etah = .5 * (eta(i,k) + eta(i,k-1))
                if(ncloud.gt.0.) then
                  dp = 1000. * del(i,k)
                  qlk = dq / (eta(i,k) + etah * (c0 + c1) * dz)
                  dellal(i,k) = etah * c1 * dz * qlk * g / dp
                else
                  qlk = dq / (eta(i,k) + etah * c0 * dz)
                endif
                qcko(i,k) = qlk + qrch
                pwo(i,k) = etah * c0 * dz * qlk
                cnvwt(i,k) = etah * qlk * g / dp
              endif
            endif
          endif
        enddo
      enddo
!
! exchange ktcon with ktcon1
!
      do i = 1, im
        if(cnvflg(i)) then
          kk = ktcon(i)
          ktcon(i) = ktcon1(i)
          ktcon1(i) = kk
        endif
      enddo
!
!  this section is ready for cloud water
!
      if(ncloud.gt.0) then
!
!  compute liquid and vapor separation at cloud top
!
!> - => Separate the total updraft cloud water at cloud top into vapor and condensate.
      do i = 1, im
        if(cnvflg(i)) then
          k = ktcon(i) - 1
          gamma = el2orc * qeso(i,k) / (to(i,k)**2)
          qrch = qeso(i,k)
     &         + gamma * dbyo(i,k) / (hvap * (1. + gamma))
          dq = qcko(i,k) - qrch
!
!  check if there is excess moisture to release latent heat
!
          if(dq.gt.0.) then
            qlko_ktcon(i) = dq
            qcko(i,k) = qrch
          endif
        endif
      enddo
      endif
!
!--- compute precipitation efficiency in terms of windshear
!
!! - Calculate the wind shear and precipitation efficiency according to equation 58 in Fritsch and Chappell (1980) \cite fritsch_and_chappell_1980 :
!! \f[
!! E = 1.591 - 0.639\frac{\Delta V}{\Delta z} + 0.0953\left(\frac{\Delta V}{\Delta z}\right)^2 - 0.00496\left(\frac{\Delta V}{\Delta z}\right)^3
!! \f]
!! where \f$\Delta V\f$ is the integrated horizontal shear over the cloud depth, \f$\Delta z\f$, (the ratio is converted to units of \f$10^{-3} s^{-1}\f$). The variable "edt" is \f$1-E\f$ and is constrained to the range \f$[0,0.9]\f$.
      do i = 1, im
        if(cnvflg(i)) then
          vshear(i) = 0.
        endif
      enddo
      do k = 2, km
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.le.ktcon(i)) then
              shear= sqrt((uo(i,k)-uo(i,k-1)) ** 2
     &                  + (vo(i,k)-vo(i,k-1)) ** 2)
              vshear(i) = vshear(i) + shear
            endif
          endif
        enddo
      enddo
      do i = 1, im
        if(cnvflg(i)) then
          vshear(i) = 1.e3 * vshear(i) / (zi(i,ktcon(i))-zi(i,kb(i)))
          e1=1.591-.639*vshear(i)
     &       +.0953*(vshear(i)**2)-.00496*(vshear(i)**3)
          edt(i)=1.-e1
          val =         .9
          edt(i) = min(edt(i),val)
          val =         .0
          edt(i) = max(edt(i),val)
        endif
      enddo
!
!--- what would the change be, that a cloud with unit mass
!--- will do to the environment?
!
!> ## Calculate the tendencies of the state variables (per unit cloud base mass flux) and the cloud base mass flux.
!> - Calculate the change in moist static energy, moisture mixing ratio, and horizontal winds per unit cloud base mass flux for all layers below cloud top from equations B.14 and B.15 from Grell (1993) \cite grell_1993, and for the cloud top from B.16 and B.17.
      do k = 1, km
        do i = 1, im
          if(cnvflg(i) .and. k .le. kmax(i)) then
            dellah(i,k) = 0.
            dellaq(i,k) = 0.
            dellau(i,k) = 0.
            dellav(i,k) = 0.
          endif
        enddo
      enddo
!
!--- changed due to subsidence and entrainment
!
      do k = 2, km1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.lt.ktcon(i)) then
              dp = 1000. * del(i,k)
              dz = zi(i,k) - zi(i,k-1)
!
              dv1h = heo(i,k)
              dv2h = .5 * (heo(i,k) + heo(i,k-1))
              dv3h = heo(i,k-1)
              dv1q = qo(i,k)
              dv2q = .5 * (qo(i,k) + qo(i,k-1))
              dv3q = qo(i,k-1)
              dv1u = uo(i,k)
              dv2u = .5 * (uo(i,k) + uo(i,k-1))
              dv3u = uo(i,k-1)
              dv1v = vo(i,k)
              dv2v = .5 * (vo(i,k) + vo(i,k-1))
              dv3v = vo(i,k-1)
!
              tem  = 0.5 * (xlamue(i,k)+xlamue(i,k-1))
              tem1 = xlamud(i)
!j
              dellah(i,k) = dellah(i,k) +
     &     ( eta(i,k)*dv1h - eta(i,k-1)*dv3h
     &    -  tem*eta(i,k-1)*dv2h*dz
     &    +  tem1*eta(i,k-1)*.5*(hcko(i,k)+hcko(i,k-1))*dz
     &         ) *g/dp
!j
              dellaq(i,k) = dellaq(i,k) +
     &     ( eta(i,k)*dv1q - eta(i,k-1)*dv3q
     &    -  tem*eta(i,k-1)*dv2q*dz
     &    +  tem1*eta(i,k-1)*.5*(qrcko(i,k)+qcko(i,k-1))*dz
     &         ) *g/dp
!j
              dellau(i,k) = dellau(i,k) +
     &     ( eta(i,k)*dv1u - eta(i,k-1)*dv3u
     &    -  tem*eta(i,k-1)*dv2u*dz
     &    +  tem1*eta(i,k-1)*.5*(ucko(i,k)+ucko(i,k-1))*dz
     &    -  pgcon*eta(i,k-1)*(dv1u-dv3u)
     &         ) *g/dp
!j
              dellav(i,k) = dellav(i,k) +
     &     ( eta(i,k)*dv1v - eta(i,k-1)*dv3v
     &    -  tem*eta(i,k-1)*dv2v*dz
     &    +  tem1*eta(i,k-1)*.5*(vcko(i,k)+vcko(i,k-1))*dz
     &    -  pgcon*eta(i,k-1)*(dv1v-dv3v)
     &         ) *g/dp
!j
            endif
          endif
        enddo
      enddo
!
!------- cloud top
!
      do i = 1, im
        if(cnvflg(i)) then
          indx = ktcon(i)
          dp = 1000. * del(i,indx)
          dv1h = heo(i,indx-1)
          dellah(i,indx) = eta(i,indx-1) *
     &                     (hcko(i,indx-1) - dv1h) * g / dp
          dv1q = qo(i,indx-1)
          dellaq(i,indx) = eta(i,indx-1) *
     &                     (qcko(i,indx-1) - dv1q) * g / dp
          dv1u = uo(i,indx-1)
          dellau(i,indx) = eta(i,indx-1) *
     &                     (ucko(i,indx-1) - dv1u) * g / dp
          dv1v = vo(i,indx-1)
          dellav(i,indx) = eta(i,indx-1) *
     &                     (vcko(i,indx-1) - dv1v) * g / dp
!
!  cloud water
!
          dellal(i,indx) = eta(i,indx-1) *
     &                     qlko_ktcon(i) * g / dp
        endif
      enddo
!
!  mass flux at cloud base for shallow convection
!  (grant, 2001)
!
!> - Calculate the cloud base mass flux according to equation 6 in Grant (2001) \cite grant_2001, based on the subcloud layer convective velocity scale, \f$w_*\f$.
!! \f[
!! M_c = 0.03\rho w_*
!! \f]
!! where \f$M_c\f$ is the cloud base mass flux, \f$\rho\f$ is the air density, and \f$w_*=\left(\frac{g}{T_0}\overline{w'\theta_v'}h\right)^{1/3}\f$ with \f$h\f$ the PBL height and other quantities have been defined previously.
      do i= 1, im
        if(cnvflg(i)) then
          k = kbcon(i)
!         ptem = g*sflx(i)*zi(i,k)/t1(i,1)
          ptem = g*sflx(i)*hpbl(i)/t1(i,1)
          wstar(i) = ptem**h1
          tem = po(i,k)*100. / (rd*t1(i,k))
          xmb(i) = betaw*tem*wstar(i)
          xmb(i) = min(xmb(i),xmbmax(i))
        endif
      enddo
!> ## For the "feedback control", calculate updated values of the state variables by multiplying the cloud base mass flux and the tendencies calculated per unit cloud base mass flux from the static control.
!! - Recalculate saturation specific humidity.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
      do k = 1, km
        do i = 1, im
          if (cnvflg(i) .and. k .le. kmax(i)) then
            qeso(i,k) = 0.01 * fpvs(t1(i,k))      ! fpvs is in pa
            qeso(i,k) = eps * qeso(i,k) / (pfld(i,k) + epsm1*qeso(i,k))
            val     =             1.e-8
            qeso(i,k) = max(qeso(i,k), val )
          endif
        enddo
      enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!> - Calculate the temperature tendency from the moist static energy and specific humidity tendencies.
!> - Update the temperature, specific humidity, and horiztonal wind state variables by multiplying the cloud base mass flux-normalized tendencies by the cloud base mass flux.
!> - Accumulate column-integrated tendencies.
      do i = 1, im
        delhbar(i) = 0.
        delqbar(i) = 0.
        deltbar(i) = 0.
        delubar(i) = 0.
        delvbar(i) = 0.
        qcond(i) = 0.
      enddo
      do k = 1, km
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.le.ktcon(i)) then
              dellat = (dellah(i,k) - hvap * dellaq(i,k)) / cp
              t1(i,k) = t1(i,k) + dellat * xmb(i) * dt2
              q1(i,k) = q1(i,k) + dellaq(i,k) * xmb(i) * dt2
!             tem = 1./rcs(i)
!             u1(i,k) = u1(i,k) + dellau(i,k) * xmb(i) * dt2 * tem
!             v1(i,k) = v1(i,k) + dellav(i,k) * xmb(i) * dt2 * tem
              u1(i,k) = u1(i,k) + dellau(i,k) * xmb(i) * dt2
              v1(i,k) = v1(i,k) + dellav(i,k) * xmb(i) * dt2
              dp = 1000. * del(i,k)
              delhbar(i) = delhbar(i) + dellah(i,k)*xmb(i)*dp/g
              delqbar(i) = delqbar(i) + dellaq(i,k)*xmb(i)*dp/g
              deltbar(i) = deltbar(i) + dellat*xmb(i)*dp/g
              delubar(i) = delubar(i) + dellau(i,k)*xmb(i)*dp/g
              delvbar(i) = delvbar(i) + dellav(i,k)*xmb(i)*dp/g
            endif
          endif
        enddo
      enddo
!> - Recalculate saturation specific humidity using the updated temperature.
      do k = 1, km
        do i = 1, im
          if (cnvflg(i)) then
            if(k.gt.kb(i).and.k.le.ktcon(i)) then
              qeso(i,k) = 0.01 * fpvs(t1(i,k))      ! fpvs is in pa
              qeso(i,k) = eps * qeso(i,k)/(pfld(i,k) + epsm1*qeso(i,k))
              val     =             1.e-8
              qeso(i,k) = max(qeso(i,k), val )
            endif
          endif
        enddo
      enddo
!
!> - Add up column-integrated convective precipitation by multiplying the normalized value by the cloud base mass flux.
      do i = 1, im
        rntot(i) = 0.
        delqev(i) = 0.
        delq2(i) = 0.
        flg(i) = cnvflg(i)
      enddo
      do k = km, 1, -1
        do i = 1, im
          if (cnvflg(i)) then
            if(k.lt.ktcon(i).and.k.gt.kb(i)) then
              rntot(i) = rntot(i) + pwo(i,k) * xmb(i) * .001 * dt2
            endif
          endif
        enddo
      enddo
!
! evaporating rain
!
!> - Determine the evaporation of the convective precipitation and update the integrated convective precipitation.
!> - Update state temperature and moisture to account for evaporation of convective precipitation.
!> - Update column-integrated tendencies to account for evaporation of convective precipitation.
      do k = km, 1, -1
        do i = 1, im
          if (k .le. kmax(i)) then
            deltv(i) = 0.
            delq(i) = 0.
            qevap(i) = 0.
            if(cnvflg(i)) then
              if(k.lt.ktcon(i).and.k.gt.kb(i)) then
                rn(i) = rn(i) + pwo(i,k) * xmb(i) * .001 * dt2
              endif
            endif
            if(flg(i).and.k.lt.ktcon(i)) then
              evef = edt(i) * evfact
              if(islimsk(i) == 1) evef=edt(i) * evfactl
!             if(islimsk(i) == 1) evef=.07
!             if(islimsk(i) == 1) evef = 0.
              qcond(i) = evef * (q1(i,k) - qeso(i,k))
     &                 / (1. + el2orc * qeso(i,k) / t1(i,k)**2)
              dp = 1000. * del(i,k)
              if(rn(i).gt.0..and.qcond(i).lt.0.) then
                qevap(i) = -qcond(i) * (1.-exp(-.32*sqrt(dt2*rn(i))))
                qevap(i) = min(qevap(i), rn(i)*1000.*g/dp)
                delq2(i) = delqev(i) + .001 * qevap(i) * dp / g
              endif
              if(rn(i).gt.0..and.qcond(i).lt.0..and.
     &           delq2(i).gt.rntot(i)) then
                qevap(i) = 1000.* g * (rntot(i) - delqev(i)) / dp
                flg(i) = .false.
              endif
              if(rn(i).gt.0..and.qevap(i).gt.0.) then
                tem  = .001 * dp / g
                tem1 = qevap(i) * tem
                if(tem1.gt.rn(i)) then
                  qevap(i) = rn(i) / tem
                  rn(i) = 0.
                else
                  rn(i) = rn(i) - tem1
                endif
                q1(i,k) = q1(i,k) + qevap(i)
                t1(i,k) = t1(i,k) - elocp * qevap(i)
                deltv(i) = - elocp*qevap(i)/dt2
                delq(i) =  + qevap(i)/dt2
                delqev(i) = delqev(i) + .001*dp*qevap(i)/g
              endif
              dellaq(i,k) = dellaq(i,k) + delq(i) / xmb(i)
              delqbar(i) = delqbar(i) + delq(i)*dp/g
              deltbar(i) = deltbar(i) + deltv(i)*dp/g
            endif
          endif
        enddo
      enddo
!j
!     do i = 1, im
!     if(me.eq.31.and.cnvflg(i)) then
!     if(cnvflg(i)) then
!       print *, ' shallow delhbar, delqbar, deltbar = ',
!    &             delhbar(i),hvap*delqbar(i),cp*deltbar(i)
!       print *, ' shallow delubar, delvbar = ',delubar(i),delvbar(i)
!       print *, ' precip =', hvap*rn(i)*1000./dt2
!       print*,'pdif= ',pfld(i,kbcon(i))-pfld(i,ktcon(i))
!     endif
!     enddo
!j
      do i = 1, im
        if(cnvflg(i)) then
          if(rn(i).lt.0..or..not.flg(i)) rn(i) = 0.
          ktop(i) = ktcon(i)
          kbot(i) = kbcon(i)
          kcnv(i) = 0
        endif
      enddo
!
!  convective cloud water
!
!> - Calculate shallow convective cloud water.
      do k = 1, km
        do i = 1, im
          if (cnvflg(i) .and. rn(i).gt.0.) then
            if (k.ge.kbcon(i).and.k.lt.ktcon(i)) then
              cnvw(i,k) = cnvwt(i,k) * xmb(i) * dt2
            endif
          endif
        enddo
      enddo

!
!  convective cloud cover
!
!> - Calculate shallow convective cloud cover.
      do k = 1, km
        do i = 1, im
          if (cnvflg(i) .and. rn(i).gt.0.) then
            if (k.ge.kbcon(i).and.k.lt.ktcon(i)) then
              cnvc(i,k) = 0.04 * log(1. + 675. * eta(i,k) * xmb(i))
              cnvc(i,k) = min(cnvc(i,k), 0.2)
              cnvc(i,k) = max(cnvc(i,k), 0.0)
            endif
          endif
        enddo
      enddo

!
!  cloud water
!
!> - Separate detrained cloud water into liquid and ice species as a function of temperature only.
      if (ncloud.gt.0) then
!
      do k = 1, km1
        do i = 1, im
          if (cnvflg(i)) then
            if (k.gt.kb(i).and.k.le.ktcon(i)) then
              tem  = dellal(i,k) * xmb(i) * dt2
              tem1 = max(0.0, min(1.0, (tcr-t1(i,k))*tcrf))
              if (qlc(i,k) .gt. -999.0) then
                qli(i,k) = qli(i,k) + tem * tem1            ! ice
                qlc(i,k) = qlc(i,k) + tem *(1.0-tem1)       ! water
              else
                qli(i,k) = qli(i,k) + tem
              endif
            endif
          endif
        enddo
      enddo
!
      endif
!
! hchuang code change
!
!> - Calculate the updraft shallow convective mass flux.
      do k = 1, km
        do i = 1, im
          if(cnvflg(i)) then
            if(k.ge.kb(i) .and. k.lt.ktop(i)) then
              ud_mf(i,k) = eta(i,k) * xmb(i) * dt2
            endif
          endif
        enddo
      enddo
!> - Calculate the detrainment mass flux at shallow cloud top.
      do i = 1, im
        if(cnvflg(i)) then
           k = ktop(i)-1
           dt_mf(i,k) = ud_mf(i,k)
        endif
      enddo
!!
      return

      end subroutine shalcnv_run

      end module shalcnv
!> @}
!! @}
