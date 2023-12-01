# 1 "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics/physics/satmedmfvdifq.F"
!> \file satmedmfvdifq.F
!! This file contains the 1-compliant SATMEDMF scheme (updated version) which
!! computes subgrid vertical turbulence mixing using scale-aware TKE-based moist
!! eddy-diffusion mass-flux (TKE-EDMF) parameterization (by Jongil Han).

      module satmedmfvdifq

      contains

!> \defgroup satmedmfvdifq GFS Scale-aware TKE-based Moist Eddy-Diffusivity Mass-flux (TKE-EDMF, updated version) Scheme Module
!! @{
!! \brief This subroutine contains all of the logic for the
!! scale-aware TKE-based moist eddy-diffusion mass-flux (TKE-EDMF, updated version) scheme.
!! For local turbulence mixing, a TKE closure model is used.
!! Updated version of satmedmfvdif.f (May 2019) to have better low level
!! inversion, to reduce the cold bias in lower troposphere,
!! and to reduce the negative wind speed bias in upper troposphere

!> \section arg_table_satmedmfvdifq_init Argument Table
!! \htmlinclude satmedmfvdifq_init.html
!!
      subroutine satmedmfvdifq_init (isatmedmf,isatmedmf_vdifq,
     &                               errmsg,errflg)

      integer, intent(in) :: isatmedmf,isatmedmf_vdifq
      character(len=*), intent(out) :: errmsg
      integer,          intent(out) :: errflg

! Initialize 1 error handling variables
      errmsg = ''
      errflg = 0

      if (.not. isatmedmf==isatmedmf_vdifq) then
        write(errmsg,fmt='(*(a))') 'Logic error: satmedmfvdif is ',
     &                   'called, but isatmedmf/=isatmedmf_vdifq.'
        errflg = 1
        return
      end if

      end subroutine satmedmfvdifq_init

      subroutine satmedmfvdifq_finalize ()
      end subroutine satmedmfvdifq_finalize

!> \section arg_table_satmedmfvdifq_run Argument Table
!! \htmlinclude satmedmfvdifq_run.html
!!
!!\section gen_satmedmfvdifq GFS satmedmfvdifq General Algorithm
!! satmedmfvdifq_run() computes subgrid vertical turbulence mixing
!! using the scale-aware TKE-based moist eddy-diffusion mass-flux (EDMF) parameterization of
!! Han and Bretherton (2019) \cite Han_2019 .
!! -# The local turbulent mixing is represented by an eddy-diffusivity scheme which
!! is a function of a prognostic TKE.
!! -# For the convective boundary layer, nonlocal transport by large eddies
!! (mfpbltq.f), is represented using a mass flux approach (Siebesma et al.(2007) \cite Siebesma_2007 ).
!! -# A mass-flux approach is also used to represent the stratocumulus-top-induced turbulence
!! (mfscuq.f).
!! \section detail_satmedmfvidfq GFS satmedmfvdifq Detailed Algorithm
!! @{
      subroutine satmedmfvdifq_run(im,km,ntrac,ntcw,ntiw,ntke,          
     &     grav,rd,cp,rv,hvap,hfus,fv,eps,epsm1,                        
     &     dv,du,tdt,rtg,u1,v1,t1,q1,swh,hlw,xmu,garea,islimsk,         
     &     snwdph_lnd,psk,rbsoil,zorl,u10m,v10m,fm,fh,                  
     &     tsea,heat,evap,stress,spd1,kpbl,                             
     &     prsi,del,prsl,prslk,phii,phil,delt,                          
     &     dspheat,dusfc,dvsfc,dtsfc,dqsfc,hpbl,                        
     &     kinver,xkzm_m,xkzm_h,xkzm_s,dspfac,bl_upfr,bl_dnfr,          
     &     ntoz,du3dt,dv3dt,dt3dt,dq3dt,do3dt,ldiag3d,qdiag3d,          
     &     errmsg,errflg)
!
      use machine  , only : kind_phys
      use funcphys , only : fpvs
!
      implicit none
!
!----------------------------------------------------------------------
      integer, intent(in)  :: im, km, ntrac, ntcw, ntiw, ntke, ntoz
      integer, intent(in)  :: kinver(im)
      integer, intent(in)  :: islimsk(im)
      integer, intent(out) :: kpbl(im)
      logical, intent(in)  :: ldiag3d,qdiag3d
!
      real(kind=kind_phys), intent(in) :: grav,rd,cp,rv,hvap,hfus,fv,   
     &                                    eps,epsm1
      real(kind=kind_phys), intent(in) :: delt, xkzm_m, xkzm_h, xkzm_s
      real(kind=kind_phys), intent(in) :: dspfac, bl_upfr, bl_dnfr
      real(kind=kind_phys), intent(inout) :: dv(im,km),     du(im,km),  
     &                     tdt(im,km),    rtg(im,km,ntrac)
      real(kind=kind_phys), intent(in) ::                               
     &                     u1(im,km),     v1(im,km),                    
     &                     t1(im,km),     q1(im,km,ntrac),              
     &                     swh(im,km),    hlw(im,km),                   
     &                     xmu(im),       garea(im),                    
     &                     snwdph_lnd(im),                              
     &                     psk(im),       rbsoil(im),                   
     &                     zorl(im),      tsea(im),                     
     &                     u10m(im),      v10m(im),                     
     &                     fm(im),        fh(im),                       
     &                     evap(im),      heat(im),                     
     &                     stress(im),    spd1(im),                     
     &                     prsi(im,km+1), del(im,km),                   
     &                     prsl(im,km),   prslk(im,km),                 
     &                     phii(im,km+1), phil(im,km)
      real(kind=kind_phys), intent(inout), dimension(:,:) ::            
     &                     du3dt(:,:),    dv3dt(:,:),                   
     &                     dt3dt(:,:),    dq3dt(:,:),                   
     &                     do3dt(:,:)
      real(kind=kind_phys), intent(out) ::                              
     &                     dusfc(im),     dvsfc(im),                    
     &                     dtsfc(im),     dqsfc(im),                    
     &                     hpbl(im)
!
      logical, intent(in)  :: dspheat
      character(len=*), intent(out) :: errmsg
      integer,          intent(out) :: errflg

!          flag for tke dissipative heating
!
!----------------------------------------------------------------------
!***
!***  local variables
!***
      integer i,is,k,kk,n,ndt,km1,kmpbl,kmscu,ntrac1
      integer lcld(im),kcld(im),krad(im),mrad(im)
      integer kx1(im), kpblx(im)
!
      real(kind=kind_phys) tke(im,km),  tkeh(im,km-1)
!
      real(kind=kind_phys) theta(im,km),thvx(im,km),  thlvx(im,km),
     &                     qlx(im,km),  thetae(im,km),thlx(im,km),
     &                     slx(im,km),  svx(im,km),   qtx(im,km),
     &                     tvx(im,km),  pix(im,km),   radx(im,km-1),
     &                     dku(im,km-1),dkt(im,km-1), dkq(im,km-1),
     &                     cku(im,km-1),ckt(im,km-1)
!
      real(kind=kind_phys) plyr(im,km), rhly(im,km),  cfly(im,km),
     &                     qstl(im,km)
!
      real(kind=kind_phys) dtdz1(im), gdx(im),
     &                     phih(im),  phim(im),    prn(im,km-1),
     &                     rbdn(im),  rbup(im),    thermal(im),
     &                     ustar(im), wstar(im),   hpblx(im),
     &                     ust3(im),  wst3(im),
     &                     z0(im),    crb(im),
     &                     hgamt(im), hgamq(im),
     &                     wscale(im),vpert(im),
     &                     zol(im),   sflux(im),
     &                     tx1(im),   tx2(im)
!
      real(kind=kind_phys) radmin(im)
!
      real(kind=kind_phys) zi(im,km+1),  zl(im,km),   zm(im,km),
     &                     xkzo(im,km-1),xkzmo(im,km-1),
     &                     xkzm_hx(im),  xkzm_mx(im), tkmnz(im,km-1),
     &                     rdzt(im,km-1),rlmnz(im,km),
     &                     al(im,km-1),  ad(im,km),   au(im,km-1),
     &                     f1(im,km),    f2(im,km*(ntrac-1))
!
      real(kind=kind_phys) elm(im,km),   ele(im,km),
     &                     ckz(im,km),   chz(im,km),  frik(im),
     &                     diss(im,km-1),prod(im,km-1), 
     &                     bf(im,km-1),  shr2(im,km-1),
     &                     xlamue(im,km-1), xlamde(im,km-1),
     &                     gotvx(im,km), rlam(im,km-1)
!
!   variables for updrafts (thermals)
!
      real(kind=kind_phys) tcko(im,km),  qcko(im,km,ntrac),
     &                     ucko(im,km),  vcko(im,km),
     &                     buou(im,km),  xmf(im,km)
!
!   variables for stratocumulus-top induced downdrafts
!
      real(kind=kind_phys) tcdo(im,km),  qcdo(im,km,ntrac),
     &                     ucdo(im,km),  vcdo(im,km),
     &                     buod(im,km),  xmfd(im,km)
!
      logical  pblflg(im), sfcflg(im), flg(im)
      logical  scuflg(im), pcnvflg(im)
      logical  mlenflg
!
!  pcnvflg: true for unstable pbl
!
      real(kind=kind_phys) aphi16,  aphi5,
     &                     wfac,    cfac,
     &                     gamcrt,  gamcrq, sfcfrac,
     &                     conq,    cont,   conw,
     &                     dsdz2,   dsdzt,  dkmax,
     &                     dsig,    dt2,    dtodsd,
     &                     dtodsu,  g,      factor, dz,
     &                     gocp,    gravi,  zol1,   zolcru,
     &                     buop,    shrp,   dtn,
     &                     prnum,   prmax,  prmin,  prtke,
     &                     prscu,   pr0,    ri,
     &                     dw2,     dw2min, zk,
     &                     elmfac,  elefac, dspmax,
     &                     alp,     clwt,   cql,
     &                     f0,      robn,   crbmin, crbmax,
     &                     es,      qs,     value,  onemrh,
     &                     cfh,     gamma,  elocp,  el2orc,
     &                     epsi,    beta,   chx,    cqx,
     &                     rdt,     rdz,    qmin,   qlmin,
     &                     rimin,   rbcr,   rbint,  tdzmin,
     &                     rlmn,    rlmn1,  rlmn2,
     &                     rlmx,    elmx,
     &                     ttend,   utend,  vtend,  qtend,
     &                     zfac,    zfmin,  vk,     spdk2,
     &                     tkmin,   tkminx, xkzinv, xkgdx,
     &                     zlup,    zldn,   bsum,
     &                     tem,     tem1,   tem2,
     &                     ptem,    ptem0,  ptem1,  ptem2
!
      real(kind=kind_phys)       xkzm_mp, xkzm_hp
!
      real(kind=kind_phys) ck0, ck1, ch0, ch1, ce0, rchck
!
      real(kind=kind_phys) qlcr, zstblmax
!
      real(kind=kind_phys) h1
!!
      parameter(wfac=7.0,cfac=3.0)
      parameter(gamcrt=3.,gamcrq=0.,sfcfrac=0.1)
      parameter(vk=0.4,rimin=-100.)
      parameter(rbcr=0.25,zolcru=-0.02,tdzmin=1.e-3)
      parameter(rlmn=30.,rlmn1=5.,rlmn2=10.)
      parameter(rlmx=300.,elmx=300.)
      parameter(prmin=0.25,prmax=4.0)
      parameter(pr0=1.0,prtke=1.0,prscu=0.67)
      parameter(f0=1.e-4,crbmin=0.15,crbmax=0.35)
      parameter(tkmin=1.e-9,tkminx=0.2,dspmax=10.0)
      parameter(qmin=1.e-8,qlmin=1.e-12,zfmin=1.e-8)
      parameter(aphi5=5.,aphi16=16.)
      parameter(elmfac=1.0,elefac=1.0,cql=100.)
      parameter(dw2min=1.e-4,dkmax=1000.,xkgdx=5000.)
      parameter(qlcr=3.5e-5,zstblmax=2500.,xkzinv=0.1)
      parameter(h1=0.33333333)
      parameter(ck0=0.4,ck1=0.15,ch0=0.4,ch1=0.15)
      parameter(ce0=0.4)
      parameter(rchck=1.5,ndt=20)

      gravi=1.0/grav
      g=grav
      gocp=g/cp
      cont=cp/g
      conq=hvap/g
      conw=1.0/g  ! for del in pa
!     parameter(cont=1000.*cp/g,conq=1000.*hvap/g,conw=1000./g) !kpa
      elocp=hvap/cp
      el2orc=hvap*hvap/(rv*cp)
!
!************************************************************************
! Initialize 1 error handling variables
      errmsg = ''
      errflg = 0

!> ## Compute preliminary variables from input arguments
      dt2  = delt
      rdt = 1. / dt2
!
! the code is written assuming ntke=ntrac
! if ntrac > ntke, the code needs to be modified
!
      ntrac1 = ntrac - 1
      km1 = km - 1
      kmpbl = km / 2
      kmscu = km / 2
!>  - Compute physical height of the layer centers and interfaces from
!! the geopotential height (\p zi and \p zl)
      do k=1,km
        do i=1,im
          zi(i,k) = phii(i,k) * gravi
          zl(i,k) = phil(i,k) * gravi
          xmf(i,k) = 0.
          xmfd(i,k) = 0.
          buou(i,k) = 0.
          buod(i,k) = 0.
          ckz(i,k) = ck1
          chz(i,k) = ch1
          rlmnz(i,k) = rlmn
        enddo
      enddo
      do i=1,im
        frik(i) = 1.0
      enddo
      do i=1,im
        zi(i,km+1) = phii(i,km+1) * gravi
      enddo
      do k=1,km
        do i=1,im
          zm(i,k) = zi(i,k+1)
        enddo
      enddo
!>  - Compute horizontal grid size (\p gdx)
      do i=1,im
        gdx(i) = sqrt(garea(i))
      enddo
!>  - Initialize tke value at vertical layer centers and interfaces
!! from tracer (\p tke and \p tkeh)
      do k=1,km
        do i=1,im
          tke(i,k) = max(q1(i,k,ntke), tkmin)
        enddo
      enddo
      do k=1,km1
        do i=1,im
          tkeh(i,k) = 0.5 * (tke(i,k) + tke(i,k+1))
        enddo
      enddo
!>  - Compute reciprocal of \f$ \Delta z \f$ (rdzt)
      do k = 1,km1
        do i=1,im
          rdzt(i,k) = 1.0 / (zl(i,k+1) - zl(i,k))
          prn(i,k)  = pr0
        enddo
      enddo
!
!>  - Compute reciprocal of pressure (tx1, tx2)

!>  - Compute minimum turbulent mixing length (rlmnz)

!>  - Compute background vertical diffusivities for scalars and momentum (xkzo and xkzmo)

!>  - set background diffusivities as a function of
!!    horizontal grid size with xkzm_h & xkzm_m for gdx >= 25km
!!    and 0.01 for gdx=5m, i.e.,
!!    \n  xkzm_hx = 0.01 + (xkzm_h - 0.01)/(xkgdx-5.) * (gdx-5.)
!!    \n  xkzm_mx = 0.01 + (xkzm_h - 0.01)/(xkgdx-5.) * (gdx-5.)

      do i=1,im
        xkzm_mp = xkzm_m
        xkzm_hp = xkzm_h
!
        if( islimsk(i) == 1 .and. snwdph_lnd(i) > 10.0 ) then    ! over land
           if (rbsoil(i) > 0. .and. rbsoil(i) <= 0.25) then
             xkzm_mp = xkzm_m * (1.0 - rbsoil(i)/0.25)**2 +
     &                     0.1 * (1.0 - (1.0-rbsoil(i)/0.25)**2)
             xkzm_hp = xkzm_h * (1.0 - rbsoil(i)/0.25)**2 +
     &                     0.1 * (1.0 - (1.0-rbsoil(i)/0.25)**2)
           else if (rbsoil(i) > 0.25) then
             xkzm_mp = 0.1
             xkzm_hp = 0.1
           endif
        endif
!
        kx1(i) = 1
        tx1(i) = 1.0 / prsi(i,1)
        tx2(i) = tx1(i)
        if(gdx(i) >= xkgdx) then
          xkzm_hx(i) = xkzm_hp
          xkzm_mx(i) = xkzm_mp
        else
          tem  = 1. / (xkgdx - 5.)
          tem1 = (xkzm_hp - 0.01) * tem
          tem2 = (xkzm_mp - 0.01) * tem
          ptem = gdx(i) - 5.
          xkzm_hx(i) = 0.01 + tem1 * ptem
          xkzm_mx(i) = 0.01 + tem2 * ptem
        endif
      enddo
      do k = 1,km1
        do i=1,im
          xkzo(i,k)  = 0.0
          xkzmo(i,k) = 0.0
          if (k < kinver(i)) then
!                               minimum turbulent mixing length
            ptem      = prsl(i,k) * tx1(i)
            tem1      = 1.0 - ptem
            tem2      = tem1 * tem1 * 2.5
            tem2      = min(1.0, exp(-tem2))
            rlmnz(i,k)= rlmn * tem2
            rlmnz(i,k)= max(rlmnz(i,k), rlmn1)
!                               vertical background diffusivity
            ptem      = prsi(i,k+1) * tx1(i)
            tem1      = 1.0 - ptem
            tem2      = tem1 * tem1 * 10.0
            tem2      = min(1.0, exp(-tem2))
            xkzo(i,k) = xkzm_hx(i) * tem2
!                               vertical background diffusivity for momentum
            if (ptem >= xkzm_s) then
              xkzmo(i,k) = xkzm_mx(i)
              kx1(i)     = k + 1
            else
              if (k == kx1(i) .and. k > 1) tx2(i) = 1.0 / prsi(i,k)
              tem1 = 1.0 - prsi(i,k+1) * tx2(i)
              tem1 = tem1 * tem1 * 5.0
              xkzmo(i,k) = xkzm_mx(i) * min(1.0, exp(-tem1))
            endif
          endif
        enddo
      enddo

!>  - Some output variables and logical flags are initialized
      do i = 1,im
         z0(i)    = 0.01 * zorl(i)
         dusfc(i) = 0.
         dvsfc(i) = 0.
         dtsfc(i) = 0.
         dqsfc(i) = 0.
         kpbl(i) = 1
         hpbl(i) = 0.
         kpblx(i) = 1
         hpblx(i) = 0.
         pblflg(i)= .true.
         sfcflg(i)= .true.
         if(rbsoil(i) > 0.) sfcflg(i) = .false.
         pcnvflg(i)= .false.
         scuflg(i)= .true.
         if(scuflg(i)) then
           radmin(i)= 0.
           mrad(i)  = km1
           krad(i)  = 1
           lcld(i)  = km1
           kcld(i)  = km1
         endif
      enddo

!>  - Compute \f$\theta\f$(theta), and \f$q_l\f$(qlx), \f$\theta_e\f$(thetae),
!! \f$\theta_v\f$(thvx),\f$\theta_{l,v}\f$ (thlvx) including ice water
      do k=1,km
        do i=1,im
          pix(i,k)   = psk(i) / prslk(i,k)
          theta(i,k) = t1(i,k) * pix(i,k)
          if(ntiw > 0) then
            tem = max(q1(i,k,ntcw),qlmin)
            tem1 = max(q1(i,k,ntiw),qlmin)
            qlx(i,k) = tem + tem1
            ptem = hvap*tem + (hvap+hfus)*tem1
            slx(i,k)   = cp * t1(i,k) + phil(i,k) - ptem
          else
            qlx(i,k) = max(q1(i,k,ntcw),qlmin)
            slx(i,k)   = cp * t1(i,k) + phil(i,k) - hvap*qlx(i,k)
          endif
          tem2       = 1.+fv*max(q1(i,k,1),qmin)-qlx(i,k)
          thvx(i,k)  = theta(i,k) * tem2
          tvx(i,k)   = t1(i,k) * tem2
          qtx(i,k) = max(q1(i,k,1),qmin)+qlx(i,k)
          thlx(i,k)  = theta(i,k) - pix(i,k)*elocp*qlx(i,k)
          thlvx(i,k) = thlx(i,k) * (1. + fv * qtx(i,k))
          svx(i,k)   = cp * tvx(i,k)
          ptem1      = elocp * pix(i,k) * max(q1(i,k,1),qmin)
          thetae(i,k)= theta(i,k) +  ptem1
          gotvx(i,k) = g / tvx(i,k)
        enddo
      enddo

!>  - Compute an empirical cloud fraction based on
!! Xu and Randall (1996) \cite xu_and_randall_1996
      do k = 1, km
        do i = 1, im
          plyr(i,k)   = 0.01 * prsl(i,k)   ! pa to mb (hpa)
!  --- ...  compute relative humidity
          es  = 0.01 * fpvs(t1(i,k))       ! fpvs in pa
          qs  = max(qmin, eps * es / (plyr(i,k) + epsm1*es))
          rhly(i,k) = max(0.0, min(1.0, max(qmin, q1(i,k,1))/qs))
          qstl(i,k) = qs
        enddo
      enddo
!
      do k = 1, km
        do i = 1, im
          cfly(i,k) = 0.
          clwt = 1.0e-6 * (plyr(i,k)*0.001)
          if (qlx(i,k) > clwt) then
            onemrh= max(1.e-10, 1.0-rhly(i,k))
            tem1  = min(max((onemrh*qstl(i,k))**0.49,0.0001),1.0)
            tem1  = cql / tem1
            value = max(min( tem1*qlx(i,k), 50.0), 0.0)
            tem2  = sqrt(sqrt(rhly(i,k)))
            cfly(i,k) = min(max(tem2*(1.0-exp(-value)), 0.0), 1.0)
          endif
        enddo
      enddo
!
!>  - Compute buoyancy modified by clouds
!
      do k = 1, km1
        do i = 1, im
          tem  = 0.5 * (svx(i,k) + svx(i,k+1))
          tem1 = 0.5 * (t1(i,k) + t1(i,k+1))
          tem2 = 0.5 * (qstl(i,k) + qstl(i,k+1))
          cfh  = min(cfly(i,k+1),0.5*(cfly(i,k)+cfly(i,k+1)))
          alp  = g / tem
          gamma = el2orc * tem2 / (tem1**2)
          epsi  = tem1 / elocp
          beta  = (1. + gamma*epsi*(1.+fv)) / (1. + gamma)
          chx   = cfh * alp * beta + (1. - cfh) * alp
          cqx   = cfh * alp * hvap * (beta - epsi)
          cqx   = cqx + (1. - cfh) * fv * g
          ptem1 = (slx(i,k+1)-slx(i,k))*rdzt(i,k)
          ptem2 = (qtx(i,k+1)-qtx(i,k))*rdzt(i,k)
          bf(i,k) = chx * ptem1 + cqx * ptem2
        enddo
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!>  - Initialize diffusion coefficients to 0 and calculate the total
!! radiative heating rate (dku, dkt, radx)
      do k=1,km1
        do i=1,im
          dku(i,k)  = 0.
          dkt(i,k)  = 0.
          dkq(i,k)  = 0.
          cku(i,k)  = 0.
          ckt(i,k)  = 0.
          tem       = zi(i,k+1)-zi(i,k)
          radx(i,k) = tem*(swh(i,k)*xmu(i)+hlw(i,k))
        enddo
      enddo
!>  - Compute stable/unstable PBL flag (pblflg) based on the total
!! surface energy flux (\e false if the total surface energy flux
!! is into the surface)
      do i = 1,im
         sflux(i)  = heat(i) + evap(i)*fv*theta(i,1)
         if(.not.sfcflg(i) .or. sflux(i) <= 0.) pblflg(i)=.false.
      enddo
!
!>  ## Calculate the PBL height
!!  The calculation of the boundary layer height follows Troen and Mahrt (1986) \cite troen_and_mahrt_1986 section 3. The approach is to find the level in the column where a modified bulk Richardson number exceeds a critical value.
!!  - Compute critical bulk Richardson number (\f$Rb_{cr}\f$) (crb)
!!  - For the unstable PBL, crb is a constant (0.25)
!!  - For the stable boundary layer (SBL), \f$Rb_{cr}\f$ varies
!!     with the surface Rossby number, \f$R_{0}\f$, as given by
!!     Vickers and Mahrt (2004) \cite Vickers_2004
!!     \f[
!!      Rb_{cr}=0.16(10^{-7}R_{0})^{-0.18}
!!     \f]
!!     \f[
!!      R_{0}=\frac{U_{10}}{f_{0}z_{0}}
!!     \f]
!!     where \f$U_{10}\f$ is the wind speed at 10m above the ground surface,
!!     \f$f_0\f$ the Coriolis parameter, and \f$z_{0}\f$ the surface roughness
!!     length. To avoid too much variation, we restrict \f$Rb_{cr}\f$ to vary
!!     within the range of 0.15~0.35
      do i = 1,im
        if(pblflg(i)) then
!         thermal(i) = thvx(i,1)
          thermal(i) = thlvx(i,1)
          crb(i) = rbcr
        else
          thermal(i) = tsea(i)*(1.+fv*max(q1(i,1,1),qmin))
          tem = sqrt(u10m(i)**2+v10m(i)**2)
          tem = max(tem, 1.)
          robn = tem / (f0 * z0(i))
          tem1 = 1.e-7 * robn
          crb(i) = 0.16 * (tem1 ** (-0.18))
          crb(i) = max(min(crb(i), crbmax), crbmin)
        endif
      enddo
!>  - Compute \f$\frac{\Delta t}{\Delta z}\f$ , \f$u_*\f$
      do i=1,im
         dtdz1(i)  = dt2 / (zi(i,2)-zi(i,1))
      enddo
!
      do i=1,im
         ustar(i) = sqrt(stress(i))
      enddo
!
!>  - Compute buoyancy \f$\frac{\partial \theta_v}{\partial z}\f$ (bf)
!! and the wind shear squared (shr2)
!
      do k = 1, km1
      do i = 1, im
         rdz  = rdzt(i,k)
!        bf(i,k) = gotvx(i,k)*(thvx(i,k+1)-thvx(i,k))*rdz
         dw2  = (u1(i,k)-u1(i,k+1))**2
     &        + (v1(i,k)-v1(i,k+1))**2
         shr2(i,k) = max(dw2,dw2min)*rdz*rdz
      enddo
      enddo
!
! Find pbl height based on bulk richardson number (mrf pbl scheme)
!   and also for diagnostic purpose
!
      do i=1,im
         flg(i) = .false.
         rbup(i) = rbsoil(i)
      enddo
!>  - Given the thermal's properties and the critical Richardson number,
!! a loop is executed to find the first level above the surface (kpblx) where
!! the modified Richardson number is greater than the critical Richardson
!! number, using equation 10a from Troen and Mahrt (1996) \cite troen_and_mahrt_1986
!! (also equation 8 from Hong and Pan (1996) \cite hong_and_pan_1996):
      do k = 1, kmpbl
      do i = 1, im
        if(.not.flg(i)) then
          rbdn(i) = rbup(i)
          spdk2   = max((u1(i,k)**2+v1(i,k)**2),1.)
!         rbup(i) = (thvx(i,k)-thermal(i))*
!    &              (g*zl(i,k)/thvx(i,1))/spdk2
          rbup(i) = (thlvx(i,k)-thermal(i))*
     &              (g*zl(i,k)/thlvx(i,1))/spdk2
          kpblx(i) = k
          flg(i)  = rbup(i) > crb(i)
        endif
      enddo
      enddo
!>  - Once the level is found, some linear interpolation is performed to find
!! the exact height of the boundary layer top (where \f$R_{i} > Rb_{cr}\f$)
!! and the PBL height (hpbl and kpbl) and the PBL top index are saved.
      do i = 1,im
        if(kpblx(i) > 1) then
          k = kpblx(i)
          if(rbdn(i) >= crb(i)) then
            rbint = 0.
          elseif(rbup(i) <= crb(i)) then
            rbint = 1.
          else
            rbint = (crb(i)-rbdn(i))/(rbup(i)-rbdn(i))
          endif
          hpblx(i) = zl(i,k-1) + rbint*(zl(i,k)-zl(i,k-1))
          if(hpblx(i) < zi(i,kpblx(i))) kpblx(i)=kpblx(i)-1
        else
          hpblx(i) = zl(i,1)
          kpblx(i) = 1
        endif
        hpbl(i) = hpblx(i)
        kpbl(i) = kpblx(i)
        if(kpbl(i) <= 1) pblflg(i)=.false.
      enddo
!
!> ## Compute Monin-Obukhov similarity parameters
!!  - Calculate the Monin-Obukhov nondimensional stability paramter, commonly
!!    referred to as \f$\zeta\f$ using the following equation from Businger et al.(1971) \cite businger_et_al_1971
!!    (eqn 28):
!!    \f[
!!    \zeta = Ri_{sfc}\frac{F_m^2}{F_h} = \frac{z}{L}
!!    \f]
!!    where \f$F_m\f$ and \f$F_h\f$ are surface Monin-Obukhov stability functions calculated in sfc_diff.f and
!!    \f$L\f$ is the Obukhov length.
      do i=1,im
         zol(i) = max(rbsoil(i)*fm(i)*fm(i)/fh(i),rimin)
         if(sfcflg(i)) then
           zol(i) = min(zol(i),-zfmin)
         else
           zol(i) = max(zol(i),zfmin)
         endif
!>  - Calculate the nondimensional gradients of momentum and temperature (\f$\phi_m\f$ (phim) and \f$\phi_h\f$(phih)) are calculated using
!! eqns 5 and 6 from Hong and Pan (1996) \cite hong_and_pan_1996 depending on the surface layer stability:
!!   - For the unstable and neutral conditions:
!!     \f[
!!     \phi_m=(1-16\frac{0.1h}{L})^{-1/4}
!!     \phi_h=(1-16\frac{0.1h}{L})^{-1/2}
!!     \f]
!!   - For the stable regime
!!     \f[
!!     \phi_m=\phi_t=(1+5\frac{0.1h}{L})
!!     \f]
         zol1 = zol(i)*sfcfrac*hpbl(i)/zl(i,1)
         if(sfcflg(i)) then
           tem     = 1.0 / (1. - aphi16*zol1)
           phih(i) = sqrt(tem)
           phim(i) = sqrt(phih(i))
         else
           phim(i) = 1. + aphi5*zol1
           phih(i) = phim(i)
         endif
      enddo
!
!>  - The \f$z/L\f$ (zol) is used as the stability criterion for the PBL.Currently,
!!    strong unstable (convective) PBL for \f$z/L < -0.02\f$ and weakly and moderately
!!    unstable PBL for \f$0>z/L>-0.02\f$
!>  - Compute the velocity scale \f$w_s\f$ (wscale) (eqn 22 of Han et al. 2019). It
!!    is represented by the value scaled at the top of the surface layer:
!!    \f[
!!    w_s=(u_*^3+7\alpha\kappa w_*^3)^{1/3}
!!    \f]
!!    where \f$u_*\f$ (ustar) is the surface friction velocity,\f$\alpha\f$ is the ratio
!!    of the surface layer height to the PBL height (specified as sfcfrac =0.1),
!!    \f$\kappa =0.4\f$ is the von Karman constant, and \f$w_*\f$ is the convective velocity
!!    scale defined as eqn23 of Han et al.(2019):
!!    \f[
!!    w_{*}=[(g/T)\overline{(w'\theta_v^{'})}_0h]^{1/3}
!!    \f]
      do i=1,im
        if(pblflg(i)) then
          if(zol(i) < zolcru) then
            pcnvflg(i) = .true.
          endif
          wst3(i) = gotvx(i,1)*sflux(i)*hpbl(i)
          wstar(i)= wst3(i)**h1
          ust3(i) = ustar(i)**3.
          wscale(i)=(ust3(i)+wfac*vk*wst3(i)*sfcfrac)**h1
          ptem = ustar(i)/aphi5
          wscale(i) = max(wscale(i),ptem)
        endif
      enddo
!
!>  ## The counter-gradient terms for temperature and humidity are calculated.
!! -  Equation 4 of Hong and Pan (1996) \cite hong_and_pan_1996 and are used to calculate the "scaled virtual temperature excess near the surface" (equation 9 in Hong and Pan (1996) \cite hong_and_pan_1996) for use in the mass-flux algorithm.
!
      do i = 1,im
         if(pcnvflg(i)) then
           hgamt(i) = heat(i)/wscale(i)
           hgamq(i) = evap(i)/wscale(i)
           vpert(i) = hgamt(i) + hgamq(i)*fv*theta(i,1)
           vpert(i) = max(vpert(i),0.)
           vpert(i) = min(cfac*vpert(i),gamcrt)
         endif
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  look for stratocumulus
!> ## Determine whether stratocumulus layers exist and compute quantities
!!  - Starting at the PBL top and going downward, if the level is less than 2.5 km
!!    and \f$q_l\geq q_{lcr}\f$ then set kcld = k (find the cloud top index in the PBL.
!!    If no cloud water above the threshold is hound, \e scuflg is set to F.
      do i=1,im
         flg(i)  = scuflg(i)
      enddo
      do k = 1, km1
        do i=1,im
          if(flg(i).and.zl(i,k) >= zstblmax) then
             lcld(i)=k
             flg(i)=.false.
          endif
      enddo
      enddo
      do i = 1, im
        flg(i)=scuflg(i)
      enddo
      do k = kmscu,1,-1
      do i = 1, im
        if(flg(i) .and. k <= lcld(i)) then
          if(qlx(i,k) >= qlcr) then
             kcld(i)=k
             flg(i)=.false.
          endif
        endif
      enddo
      enddo
      do i = 1, im
        if(scuflg(i) .and. kcld(i)==km1) scuflg(i)=.false.
      enddo
!>  - Starting at the PBL top and going downward, if the level is less
!!    than the cloud top, find the level of the minimum radiative heating
!!    rate wihin the cloud. If the level of the minimum is the lowest model
!!    level or the minimum radiative heating rate is positive, then set
!!    scuflg to F.
      do i = 1, im
        flg(i)=scuflg(i)
      enddo
      do k = kmscu,1,-1
      do i = 1, im
        if(flg(i) .and. k <= kcld(i)) then
          if(qlx(i,k) >= qlcr) then
            if(radx(i,k) < radmin(i)) then
              radmin(i)=radx(i,k)
              krad(i)=k
            endif
          else
            flg(i)=.false.
          endif
        endif
      enddo
      enddo
      do i = 1, im
        if(scuflg(i) .and. krad(i) <= 1) scuflg(i)=.false.
        if(scuflg(i) .and. radmin(i)>=0.) scuflg(i)=.false.
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> ## Compute components for mass flux mixing by large thermals
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!>  - If the PBL is convective, the updraft properties are initialized
!!    to be the same as the state variables.
      do k = 1, km
        do i = 1, im
          if(pcnvflg(i)) then
            tcko(i,k) = t1(i,k)
            ucko(i,k) = u1(i,k)
            vcko(i,k) = v1(i,k)
          endif
          if(scuflg(i)) then
            tcdo(i,k) = t1(i,k)
            ucdo(i,k) = u1(i,k)
            vcdo(i,k) = v1(i,k)
          endif
        enddo
      enddo
      do kk = 1, ntrac1
      do k = 1, km
        do i = 1, im
          if(pcnvflg(i)) then
            qcko(i,k,kk) = q1(i,k,kk)
          endif
          if(scuflg(i)) then
            qcdo(i,k,kk) = q1(i,k,kk)
          endif
        enddo
      enddo
      enddo
!>  - Call mfpbltq(), which is an EDMF parameterization (Siebesma et al.(2007) \cite Siebesma_2007)
!!    to take into account nonlocal transport by large eddies. For details of the mfpbltq subroutine, step into its documentation ::mfpbltq
      call mfpbltq(im,im,km,kmpbl,ntcw,ntrac1,dt2,
     &    pcnvflg,zl,zm,q1,t1,u1,v1,plyr,pix,thlx,thvx,
     &    gdx,hpbl,kpbl,vpert,buou,xmf,
     &    tcko,qcko,ucko,vcko,xlamue,bl_upfr)
!>  - Call mfscuq(), which is a new mass-flux parameterization for
!!    stratocumulus-top-induced turbulence mixing. For details of the mfscuq subroutine, step into its documentation ::mfscuq
      call mfscuq(im,im,km,kmscu,ntcw,ntrac1,dt2,
     &    scuflg,zl,zm,q1,t1,u1,v1,plyr,pix,
     &    thlx,thvx,thlvx,gdx,thetae,
     &    krad,mrad,radmin,buod,xmfd,
     &    tcdo,qcdo,ucdo,vcdo,xlamde,bl_dnfr)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!> ## Compute Prandtl number \f$P_r\f$ (prn) and exchange coefficient varying with height
      do k = 1, kmpbl
        do i = 1, im
          if(k < kpbl(i)) then
            tem = phih(i)/phim(i)
            ptem = sfcfrac*hpbl(i)
            tem1 = max(zi(i,k+1)-ptem, 0.)
            tem2 = tem1 / (hpbl(i) - ptem)
            if(pcnvflg(i)) then
              tem = min(tem, pr0)
              prn(i,k) = tem + (pr0 - tem) * tem2
            else
              tem = max(tem, pr0)
              prn(i,k) = tem
            endif
            prn(i,k) = min(prn(i,k),prmax)
            prn(i,k) = max(prn(i,k),prmin)
!
            ckz(i,k) = ck0 + (ck1 - ck0) * tem2
            ckz(i,k) = max(min(ckz(i,k), ck0), ck1)
            chz(i,k) = ch0 + (ch1 - ch0) * tem2
            chz(i,k) = max(min(chz(i,k), ch0), ch1)
!
          endif
        enddo
      enddo
!
!  background diffusivity decreasing with increasing surface layer stability
!
!     do i = 1, im
!       if(.not.sfcflg(i)) then
!         tem = (1. + 5. * rbsoil(i))**2.
!!        tem = (1. + 5. * zol(i))**2.
!         frik(i) = 0.1 + 0.9 / tem
!       endif
!     enddo
!
!     do k = 1,km1
!       do i=1,im
!         xkzo(i,k) = frik(i) * xkzo(i,k)
!         xkzmo(i,k)= frik(i) * xkzmo(i,k)
!       enddo
!     enddo
!
!>  ## The background vertical diffusivities in the inversion layers are limited
!!     to be less than or equal to xkzinv
!
      do k = 1,km1
        do i=1,im
!         tem1 = (tvx(i,k+1)-tvx(i,k)) * rdzt(i,k)
!         if(tem1 > 1.e-5) then
          tem1 = tvx(i,k+1)-tvx(i,k)
          if(tem1 > 0. .and. islimsk(i) /= 1) then
             xkzo(i,k)  = min(xkzo(i,k), xkzinv)
             xkzmo(i,k) = min(xkzmo(i,k), xkzinv)
             rlmnz(i,k) = min(rlmnz(i,k), rlmn2)
          endif
        enddo
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> ## Compute an asymtotic mixing length
!
      do k = 1, km1
        do i = 1, im
          zlup = 0.0
          bsum = 0.0
          mlenflg = .true.
          do n = k, km1
            if(mlenflg) then
              dz = zl(i,n+1) - zl(i,n)
              ptem = gotvx(i,n)*(thvx(i,n+1)-thvx(i,k))*dz
!             ptem = gotvx(i,n)*(thlvx(i,n+1)-thlvx(i,k))*dz
              bsum = bsum + ptem
              zlup = zlup + dz
              if(bsum >= tke(i,k)) then
                if(ptem >= 0.) then
                  tem2 = max(ptem, zfmin)
                else
                  tem2 = min(ptem, -zfmin)
                endif
                ptem1 = (bsum - tke(i,k)) / tem2
                zlup = zlup - ptem1 * dz 
                zlup = max(zlup, 0.)
                mlenflg = .false.
              endif
            endif
          enddo
          zldn = 0.0
          bsum = 0.0
          mlenflg = .true.
          do n = k, 1, -1
            if(mlenflg) then
              if(n == 1) then
                dz = zl(i,1)
                tem1 = tsea(i)*(1.+fv*max(q1(i,1,1),qmin))
              else
                dz = zl(i,n) - zl(i,n-1)
                tem1 = thvx(i,n-1)
!               tem1 = thlvx(i,n-1)
              endif
              ptem = gotvx(i,n)*(thvx(i,k)-tem1)*dz
!             ptem = gotvx(i,n)*(thlvx(i,k)-tem1)*dz
              bsum = bsum + ptem
              zldn = zldn + dz
              if(bsum >= tke(i,k)) then
                if(ptem >= 0.) then
                  tem2 = max(ptem, zfmin)
                else
                  tem2 = min(ptem, -zfmin)
                endif
                ptem1 = (bsum - tke(i,k)) / tem2
                zldn = zldn - ptem1 * dz 
                zldn = max(zldn, 0.)
                mlenflg = .false.
              endif
            endif
          enddo
!
          tem = 0.5 * (zi(i,k+1)-zi(i,k))
          tem1 = min(tem, rlmnz(i,k))
!>  - Following Bougeault and Lacarrere(1989), the characteristic length
!! scale (\f$l_2\f$) (eqn 10 in Han et al.(2019) \cite Han_2019) is given by:
!!\f[
!!   l_2=min(l_{up},l_{down})
!!\f]
!! and dissipation length scale \f$l_d\f$ is given by:
!!\f[
!!   l_d=(l_{up}l_{down})^{1/2}
!!\f]
!!    where \f$l_{up}\f$ and \f$l_{down}\f$ are the distances that a parcel
!! having an initial TKE can travel upward and downward before being stopped
!! by buoyancy effects.
          ptem2 = min(zlup,zldn)
          rlam(i,k) = elmfac * ptem2
          rlam(i,k) = max(rlam(i,k), tem1)
          rlam(i,k) = min(rlam(i,k), rlmx)
!
          ptem2 = sqrt(zlup*zldn)
          ele(i,k) = elefac * ptem2
          ele(i,k) = max(ele(i,k), tem1)
          ele(i,k) = min(ele(i,k), elmx)
!
        enddo
      enddo
!>  - Compute the surface layer length scale (\f$l_1\f$) following
!! Nakanishi (2001) \cite Nakanish_2001 (eqn 9 of Han et al.(2019) \cite Han_2019)
      do k = 1, km1
        do i = 1, im
          tem = vk * zl(i,k)
          if (zol(i) < 0.) then
            ptem = 1. - 100. * zol(i)
            ptem1 = ptem**0.2
            zk = tem * ptem1
          elseif (zol(i) >= 1.) then
            zk = tem / 3.7
          else
            ptem = 1. + 2.7 * zol(i)
            zk = tem / ptem
          endif 
          elm(i,k) = zk*rlam(i,k)/(rlam(i,k)+zk)
!
          dz = zi(i,k+1) - zi(i,k)
          tem = max(gdx(i),dz)
          elm(i,k) = min(elm(i,k), tem)
          ele(i,k) = min(ele(i,k), tem)
!
        enddo
      enddo
      do i = 1, im
        elm(i,km) = elm(i,km1)
        ele(i,km) = ele(i,km1)
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> ## Compute eddy diffusivities
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
      do k = 1, km1
        do i = 1, im
           tem = 0.5 * (elm(i,k) + elm(i,k+1))
           tem = tem * sqrt(tkeh(i,k))
           ri = max(bf(i,k)/shr2(i,k),rimin)
           if(k < kpbl(i)) then
             if(pcnvflg(i)) then
               dku(i,k) = ckz(i,k) * tem
               dkt(i,k) = dku(i,k) / prn(i,k)
             else
               if(ri < 0.) then ! unstable regime
                 dku(i,k) = ckz(i,k) * tem
                 dkt(i,k) = dku(i,k) / prn(i,k)
               else             ! stable regime
                 dkt(i,k) = chz(i,k) * tem
                 dku(i,k) = dkt(i,k) * prn(i,k)
               endif
             endif
           else
              if(ri < 0.) then ! unstable regime
                dku(i,k) = ck1 * tem
                dkt(i,k) = rchck * dku(i,k)
              else             ! stable regime
                dkt(i,k) = ch1 * tem
                prnum = 1.0 + 2.1 * ri
                prnum = min(prnum,prmax)
                dku(i,k) = dkt(i,k) * prnum
              endif
           endif
!
           if(scuflg(i)) then
             if(k >= mrad(i) .and. k < krad(i)) then
                tem1 = ckz(i,k) * tem
                ptem1 = tem1 / prscu
                dku(i,k) = max(dku(i,k), tem1)
                dkt(i,k) = max(dkt(i,k), ptem1)
             endif
           endif
!
           dkq(i,k) = prtke * dkt(i,k)
!
           dkt(i,k) = min(dkt(i,k),dkmax)
           dkt(i,k) = max(dkt(i,k),xkzo(i,k))
           dkq(i,k) = min(dkq(i,k),dkmax)
           dkq(i,k) = max(dkq(i,k),xkzo(i,k))
           dku(i,k) = min(dku(i,k),dkmax)
           dku(i,k) = max(dku(i,k),xkzmo(i,k))
!
        enddo
      enddo
!> ## Compute TKE.
!!  - Compute a minimum TKE deduced from background diffusivity for momentum.
!
      do k = 1, km1
        do i = 1, im
          if(k == 1) then
            tem = ckz(i,1)
            tem1 = 0.5 * xkzmo(i,1)
          else
            tem = 0.5 * (ckz(i,k-1) + ckz(i,k))
            tem1 = 0.5 * (xkzmo(i,k-1) + xkzmo(i,k))
          endif
          ptem = tem1 / (tem * elm(i,k))
          tkmnz(i,k) = ptem * ptem
          tkmnz(i,k) = min(tkmnz(i,k), tkminx)
          tkmnz(i,k) = max(tkmnz(i,k), tkmin)
        enddo
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!>  - Compute buoyancy and shear productions of TKE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
      do k = 1, km1
        do i = 1, im
          if (k == 1) then
            tem = -dkt(i,1) * bf(i,1)
!           if(pcnvflg(i)) then
!             ptem1 = xmf(i,1) * buou(i,1)
!           else
              ptem1 = 0.
!           endif
            if(scuflg(i) .and. mrad(i) == 1) then
              ptem2 = xmfd(i,1) * buod(i,1)
            else
              ptem2 = 0.
            endif
            tem = tem + ptem1 + ptem2
            buop = 0.5 * (gotvx(i,1) * sflux(i) + tem)
!
            tem1 = dku(i,1) * shr2(i,1)
!
            tem = (u1(i,2)-u1(i,1))*rdzt(i,1)
!           if(pcnvflg(i)) then
!             ptem = xmf(i,1) * tem
!             ptem1 = 0.5 * ptem * (u1(i,2)-ucko(i,2))
!           else
              ptem1 = 0.
!           endif
            if(scuflg(i) .and. mrad(i) == 1) then
              ptem = ucdo(i,1)+ucdo(i,2)-u1(i,1)-u1(i,2)
              ptem = 0.5 * tem * xmfd(i,1) * ptem
            else
              ptem = 0.
            endif
            ptem1 = ptem1 + ptem
!
            tem = (v1(i,2)-v1(i,1))*rdzt(i,1)
!           if(pcnvflg(i)) then
!             ptem = xmf(i,1) * tem
!             ptem2 = 0.5 * ptem * (v1(i,2)-vcko(i,2))
!           else
              ptem2 = 0.
!           endif
            if(scuflg(i) .and. mrad(i) == 1) then
              ptem = vcdo(i,1)+vcdo(i,2)-v1(i,1)-v1(i,2)
              ptem = 0.5 * tem * xmfd(i,1) * ptem
            else
              ptem = 0.
            endif
            ptem2 = ptem2 + ptem
!
!           tem2 = stress(i)*spd1(i)/zl(i,1)
            tem2 = stress(i)*ustar(i)*phim(i)/(vk*zl(i,1))
            shrp = 0.5 * (tem1 + ptem1 + ptem2 + tem2)
          else
            tem1 = -dkt(i,k-1) * bf(i,k-1)
            tem2 = -dkt(i,k) * bf(i,k)
            tem  = 0.5 * (tem1 + tem2)
            if(pcnvflg(i) .and. k <= kpbl(i)) then
              ptem = 0.5 * (xmf(i,k-1) + xmf(i,k))
              ptem1 = ptem * buou(i,k)
            else
              ptem1 = 0.
            endif
            if(scuflg(i)) then
              if(k >= mrad(i) .and. k < krad(i)) then
                ptem0 = 0.5 * (xmfd(i,k-1) + xmfd(i,k))
                ptem2 = ptem0 * buod(i,k)
              else
                ptem2 = 0.
              endif
            else
              ptem2 = 0.
            endif
            buop = tem + ptem1 + ptem2
!
            tem1 = dku(i,k-1) * shr2(i,k-1)
            tem2 = dku(i,k) * shr2(i,k)
            tem  = 0.5 * (tem1 + tem2)
            tem1 = (u1(i,k+1)-u1(i,k))*rdzt(i,k)
            tem2 = (u1(i,k)-u1(i,k-1))*rdzt(i,k-1)
            if(pcnvflg(i) .and. k <= kpbl(i)) then
              ptem = xmf(i,k) * tem1 + xmf(i,k-1) * tem2
              ptem1 = 0.5 * ptem * (u1(i,k)-ucko(i,k))
            else
              ptem1 = 0.
            endif
            if(scuflg(i)) then
              if(k >= mrad(i) .and. k < krad(i)) then
                ptem0 = xmfd(i,k) * tem1 + xmfd(i,k-1) * tem2
                ptem2 = 0.5 * ptem0 * (ucdo(i,k)-u1(i,k))
              else
                ptem2 = 0.
              endif
            else
              ptem2 = 0.
            endif
            shrp = tem + ptem1 + ptem2
            tem1 = (v1(i,k+1)-v1(i,k))*rdzt(i,k)
            tem2 = (v1(i,k)-v1(i,k-1))*rdzt(i,k-1)
            if(pcnvflg(i) .and. k <= kpbl(i)) then
              ptem = xmf(i,k) * tem1 + xmf(i,k-1) * tem2
              ptem1 = 0.5 * ptem * (v1(i,k)-vcko(i,k))
            else
              ptem1 = 0.
            endif
            if(scuflg(i)) then
              if(k >= mrad(i) .and. k < krad(i)) then
                ptem0 = xmfd(i,k) * tem1 + xmfd(i,k-1) * tem2
                ptem2 = 0.5 * ptem0 * (vcdo(i,k)-v1(i,k))
              else
                ptem2 = 0.
              endif
            else
              ptem2 = 0.
            endif
            shrp = shrp + ptem1 + ptem2
          endif
          prod(i,k) = buop + shrp
        enddo
      enddo
!
!----------------------------------------------------------------------
!>  - First predict tke due to tke production & dissipation(diss)
!
      dtn = dt2 / float(ndt)
      do n = 1, ndt
      do k = 1,km1
        do i=1,im
           tem = sqrt(tke(i,k))
           ptem = ce0 / ele(i,k)
           diss(i,k) = ptem * tke(i,k) * tem
           tem1 = prod(i,k) + tke(i,k) / dtn
           diss(i,k)=max(min(diss(i,k), tem1), 0.)
           tke(i,k) = tke(i,k) + dtn * (prod(i,k)-diss(i,k))
!          tke(i,k) = max(tke(i,k), tkmin)
           tke(i,k) = max(tke(i,k), tkmnz(i,k))
        enddo
      enddo
      enddo
!
!>  - Compute updraft & downdraft properties for TKE
!
      do k = 1, km
        do i = 1, im
          if(pcnvflg(i)) then
            qcko(i,k,ntke) = tke(i,k)
          endif
          if(scuflg(i)) then
            qcdo(i,k,ntke) = tke(i,k)
          endif
        enddo
      enddo
      do k = 2, kmpbl
        do i = 1, im
          if (pcnvflg(i) .and. k <= kpbl(i)) then
             dz   = zl(i,k) - zl(i,k-1)
             tem  = 0.5 * xlamue(i,k-1) * dz
             factor = 1. + tem
             qcko(i,k,ntke)=((1.-tem)*qcko(i,k-1,ntke)+tem*
     &                (tke(i,k)+tke(i,k-1)))/factor
          endif
        enddo
      enddo
      do k = kmscu, 1, -1
        do i = 1, im
          if (scuflg(i) .and. k < krad(i)) then
            if(k >= mrad(i)) then
              dz = zl(i,k+1) - zl(i,k)
              tem  = 0.5 * xlamde(i,k) * dz
              factor = 1. + tem
              qcdo(i,k,ntke)=((1.-tem)*qcdo(i,k+1,ntke)+tem*
     &                 (tke(i,k)+tke(i,k+1)))/factor
            endif
          endif
        enddo
      enddo
!
!----------------------------------------------------------------------
!>  - Compute tridiagonal matrix elements for turbulent kinetic energy
!
      do i=1,im
         ad(i,1) = 1.0
         f1(i,1) = tke(i,1)
      enddo
!
      do k = 1,km1
        do i=1,im
          dtodsd  = dt2/del(i,k)
          dtodsu  = dt2/del(i,k+1)
          dsig    = prsl(i,k)-prsl(i,k+1)
          rdz     = rdzt(i,k)
          tem1    = dsig * dkq(i,k) * rdz
          dsdz2   = tem1 * rdz
          au(i,k) = -dtodsd*dsdz2
          al(i,k) = -dtodsu*dsdz2
          ad(i,k) = ad(i,k)-au(i,k)
          ad(i,k+1)= 1.-al(i,k)
          tem2    = dsig * rdz
!
          if(pcnvflg(i) .and. k < kpbl(i)) then
             ptem      = 0.5 * tem2 * xmf(i,k)
             ptem1     = dtodsd * ptem
             ptem2     = dtodsu * ptem
             tem       = tke(i,k) + tke(i,k+1)
             ptem      = qcko(i,k,ntke) + qcko(i,k+1,ntke)
             f1(i,k)   = f1(i,k)-(ptem-tem)*ptem1
             f1(i,k+1) = tke(i,k+1)+(ptem-tem)*ptem2
          else
             f1(i,k+1) = tke(i,k+1)
          endif
!
          if(scuflg(i)) then
            if(k >= mrad(i) .and. k < krad(i)) then
              ptem      = 0.5 * tem2 * xmfd(i,k)
              ptem1     = dtodsd * ptem
              ptem2     = dtodsu * ptem
              tem       = tke(i,k) + tke(i,k+1)
              ptem      = qcdo(i,k,ntke) + qcdo(i,k+1,ntke)
              f1(i,k)   = f1(i,k) + (ptem - tem) * ptem1
              f1(i,k+1) = f1(i,k+1) - (ptem - tem) * ptem2
            endif
          endif
!
        enddo
      enddo
c
!>  - Call tridit() to solve tridiagonal problem for TKE
c
      call tridit(im,km,1,al,ad,au,f1,au,f1)
c
!>  - Recover the tendency of tke
c
      do k = 1,km
         do i = 1,im
!           f1(i,k) = max(f1(i,k), tkmin)
            qtend = (f1(i,k)-q1(i,k,ntke))*rdt
            rtg(i,k,ntke) = rtg(i,k,ntke)+qtend
         enddo
      enddo
c
!> ## Compute tridiagonal matrix elements for heat and moisture
c
      do i=1,im
         ad(i,1) = 1.
         f1(i,1) = t1(i,1)   + dtdz1(i) * heat(i)
         f2(i,1) = q1(i,1,1) + dtdz1(i) * evap(i)
      enddo
      if(ntrac1 >= 2) then
        do kk = 2, ntrac1
          is = (kk-1) * km
          do i = 1, im
            f2(i,1+is) = q1(i,1,kk)
          enddo
        enddo
      endif
c
      do k = 1,km1
        do i = 1,im
          dtodsd  = dt2/del(i,k)
          dtodsu  = dt2/del(i,k+1)
          dsig    = prsl(i,k)-prsl(i,k+1)
          rdz     = rdzt(i,k)
          tem1    = dsig * dkt(i,k) * rdz
          dsdzt   = tem1 * gocp
          dsdz2   = tem1 * rdz
          au(i,k) = -dtodsd*dsdz2
          al(i,k) = -dtodsu*dsdz2
          ad(i,k) = ad(i,k)-au(i,k)
          ad(i,k+1)= 1.-al(i,k)
          tem2    = dsig * rdz
!
          if(pcnvflg(i) .and. k < kpbl(i)) then
             ptem      = 0.5 * tem2 * xmf(i,k)
             ptem1     = dtodsd * ptem
             ptem2     = dtodsu * ptem
             tem       = t1(i,k) + t1(i,k+1)
             ptem      = tcko(i,k) + tcko(i,k+1)
             f1(i,k)   = f1(i,k)+dtodsd*dsdzt-(ptem-tem)*ptem1
             f1(i,k+1) = t1(i,k+1)-dtodsu*dsdzt+(ptem-tem)*ptem2
             tem       = q1(i,k,1) + q1(i,k+1,1)
             ptem      = qcko(i,k,1) + qcko(i,k+1,1)
             f2(i,k)   = f2(i,k) - (ptem - tem) * ptem1
             f2(i,k+1) = q1(i,k+1,1) + (ptem - tem) * ptem2
          else
             f1(i,k)   = f1(i,k)+dtodsd*dsdzt
             f1(i,k+1) = t1(i,k+1)-dtodsu*dsdzt
             f2(i,k+1) = q1(i,k+1,1)
          endif
!
          if(scuflg(i)) then
            if(k >= mrad(i) .and. k < krad(i)) then
              ptem      = 0.5 * tem2 * xmfd(i,k)
              ptem1     = dtodsd * ptem
              ptem2     = dtodsu * ptem
              ptem      = tcdo(i,k) + tcdo(i,k+1)
              tem       = t1(i,k) + t1(i,k+1)
              f1(i,k)   = f1(i,k) + (ptem - tem) * ptem1
              f1(i,k+1) = f1(i,k+1) - (ptem - tem) * ptem2
              tem       = q1(i,k,1) + q1(i,k+1,1)
              ptem      = qcdo(i,k,1) + qcdo(i,k+1,1)
              f2(i,k)   = f2(i,k) + (ptem - tem) * ptem1
              f2(i,k+1) = f2(i,k+1) - (ptem - tem) * ptem2
            endif
          endif
        enddo
      enddo
!
      if(ntrac1 >= 2) then
        do kk = 2, ntrac1
          is = (kk-1) * km
          do k = 1, km1
            do i = 1, im
              if(pcnvflg(i) .and. k < kpbl(i)) then
                dtodsd = dt2/del(i,k)
                dtodsu = dt2/del(i,k+1)
                dsig  = prsl(i,k)-prsl(i,k+1)
                tem   = dsig * rdzt(i,k)
                ptem  = 0.5 * tem * xmf(i,k)
                ptem1 = dtodsd * ptem
                ptem2 = dtodsu * ptem
                tem1  = qcko(i,k,kk) + qcko(i,k+1,kk)
                tem2  = q1(i,k,kk) + q1(i,k+1,kk)
                f2(i,k+is) = f2(i,k+is) - (tem1 - tem2) * ptem1
                f2(i,k+1+is)= q1(i,k+1,kk) + (tem1 - tem2) * ptem2
              else
                f2(i,k+1+is) = q1(i,k+1,kk)
              endif
!
              if(scuflg(i)) then
                if(k >= mrad(i) .and. k < krad(i)) then
                  dtodsd = dt2/del(i,k)
                  dtodsu = dt2/del(i,k+1)
                  dsig  = prsl(i,k)-prsl(i,k+1)
                  tem   = dsig * rdzt(i,k)
                  ptem  = 0.5 * tem * xmfd(i,k)
                  ptem1 = dtodsd * ptem
                  ptem2 = dtodsu * ptem
                  tem1  = qcdo(i,k,kk) + qcdo(i,k+1,kk)
                  tem2  = q1(i,k,kk) + q1(i,k+1,kk)
                  f2(i,k+is)  = f2(i,k+is) + (tem1 - tem2) * ptem1
                  f2(i,k+1+is)= f2(i,k+1+is) - (tem1 - tem2) * ptem2
                endif
              endif
!
            enddo
          enddo
        enddo
      endif
c
!> - Call tridin() to solve tridiagonal problem for heat and moisture
c
      call tridin(im,km,ntrac1,al,ad,au,f1,f2,au,f1,f2)
c
!> - Recover the tendencies of heat and moisture
c
      do  k = 1,km
         do i = 1,im
            ttend      = (f1(i,k)-t1(i,k))*rdt
            qtend      = (f2(i,k)-q1(i,k,1))*rdt
            tdt(i,k)   = tdt(i,k)+ttend
            rtg(i,k,1) = rtg(i,k,1)+qtend
            dtsfc(i)   = dtsfc(i)+cont*del(i,k)*ttend
            dqsfc(i)   = dqsfc(i)+conq*del(i,k)*qtend
         enddo
      enddo
      if(ldiag3d) then
        do  k = 1,km
          do i = 1,im
            ttend      = (f1(i,k)-t1(i,k))*rdt
            dt3dt(i,k) = dt3dt(i,k)+dspfac*ttend*delt
          enddo
        enddo
        if(qdiag3d) then
          do  k = 1,km
            do i = 1,im
              qtend      = (f2(i,k)-q1(i,k,1))*rdt
              dq3dt(i,k) = dq3dt(i,k)+dspfac*qtend*delt
            enddo
          enddo
        endif
      endif
!
      if(ntrac1 >= 2) then
        do kk = 2, ntrac1
          is = (kk-1) * km
          do k = 1, km
            do i = 1, im
              qtend = (f2(i,k+is)-q1(i,k,kk))*rdt
              rtg(i,k,kk) = rtg(i,k,kk)+qtend
            enddo
          enddo
        enddo
        if(ldiag3d .and. qdiag3d .and. ntoz>0) then
          kk=ntoz
          is = (kk-1) * km
          do k = 1, km
            do i = 1, im
              qtend = (f2(i,k+is)-q1(i,k,kk))*rdt
              do3dt(i,k) = do3dt(i,k)+qtend*delt
            enddo
          enddo
        endif
      endif
!
!> ## Add TKE dissipative heating to temperature tendency
!
      if(dspheat) then
        do k = 1,km1
          do i = 1,im
!           tem = min(diss(i,k), dspmax)
!           ttend = tem / cp
            ttend = diss(i,k) / cp
            tdt(i,k) = tdt(i,k) + dspfac * ttend
          enddo
        enddo
        if(ldiag3d) then
          do k = 1,km1
            do i = 1,im
              ttend = diss(i,k) / cp
              dt3dt(i,k) = dt3dt(i,k)+dspfac * ttend*delt
            enddo
          enddo
        endif
      endif
c
!> ## Compute tridiagonal matrix elements for momentum
c
      do i=1,im
         ad(i,1) = 1.0 + dtdz1(i) * stress(i) / spd1(i)
         f1(i,1) = u1(i,1)
         f2(i,1) = v1(i,1)
      enddo
c
      do k = 1,km1
        do i=1,im
          dtodsd  = dt2/del(i,k)
          dtodsu  = dt2/del(i,k+1)
          dsig    = prsl(i,k)-prsl(i,k+1)
          rdz     = rdzt(i,k)
          tem1    = dsig * dku(i,k) * rdz
          dsdz2   = tem1*rdz
          au(i,k) = -dtodsd*dsdz2
          al(i,k) = -dtodsu*dsdz2
          ad(i,k) = ad(i,k)-au(i,k)
          ad(i,k+1)= 1.-al(i,k)
          tem2    = dsig * rdz
!
          if(pcnvflg(i) .and. k < kpbl(i)) then
             ptem      = 0.5 * tem2 * xmf(i,k)
             ptem1     = dtodsd * ptem
             ptem2     = dtodsu * ptem
             tem       = u1(i,k) + u1(i,k+1)
             ptem      = ucko(i,k) + ucko(i,k+1)
             f1(i,k)   = f1(i,k) - (ptem - tem) * ptem1
             f1(i,k+1) = u1(i,k+1) + (ptem - tem) * ptem2
             tem       = v1(i,k) + v1(i,k+1)
             ptem      = vcko(i,k) + vcko(i,k+1)
             f2(i,k)   = f2(i,k) - (ptem - tem) * ptem1
             f2(i,k+1) = v1(i,k+1) + (ptem - tem) * ptem2
          else
             f1(i,k+1) = u1(i,k+1)
             f2(i,k+1) = v1(i,k+1)
          endif
!
          if(scuflg(i)) then
            if(k >= mrad(i) .and. k < krad(i)) then
              ptem      = 0.5 * tem2 * xmfd(i,k)
              ptem1     = dtodsd * ptem
              ptem2     = dtodsu * ptem
              tem       = u1(i,k) + u1(i,k+1)
              ptem      = ucdo(i,k) + ucdo(i,k+1)
              f1(i,k)   = f1(i,k) + (ptem - tem) *ptem1
              f1(i,k+1) = f1(i,k+1) - (ptem - tem) *ptem2
              tem       = v1(i,k) + v1(i,k+1)
              ptem      = vcdo(i,k) + vcdo(i,k+1)
              f2(i,k)   = f2(i,k) + (ptem - tem) * ptem1
              f2(i,k+1) = f2(i,k+1) - (ptem - tem) * ptem2
            endif
          endif
!
        enddo
      enddo
c
!> - Call tridi2() to solve tridiagonal problem for momentum
c
      call tridi2(im,km,al,ad,au,f1,f2,au,f1,f2)
c
!> - Recover the tendencies of momentum
c
      do k = 1,km
         do i = 1,im
            utend = (f1(i,k)-u1(i,k))*rdt
            vtend = (f2(i,k)-v1(i,k))*rdt
            du(i,k)  = du(i,k)+utend
            dv(i,k)  = dv(i,k)+vtend
            dusfc(i) = dusfc(i)+conw*del(i,k)*utend
            dvsfc(i) = dvsfc(i)+conw*del(i,k)*vtend
         enddo
      enddo
      if(ldiag3d) then
        do k = 1,km
          do i = 1,im
            utend = (f1(i,k)-u1(i,k))*rdt
            vtend = (f2(i,k)-v1(i,k))*rdt
            du3dt(i,k) = du3dt(i,k) + utend*delt
            dv3dt(i,k) = dv3dt(i,k) + vtend*delt
          enddo
        enddo
      endif
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> ## Save PBL height for diagnostic purpose
!
      do i = 1, im
         hpbl(i) = hpblx(i)
         kpbl(i) = kpblx(i)
      enddo
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      return
      end subroutine satmedmfvdifq_run
!> @}
!! @}
      end module satmedmfvdifq
