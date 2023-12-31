!>@brief The module 'stochy_data_mod' contains the initilization routine that read the stochastic phyiscs
!! namelist and determins the number of random patterns.
module stochy_data_mod

! set up and initialize stochastic random patterns.

 use spectral_layout_mod, only: len_trie_ls,len_trio_ls,ls_dim,ls_max_node
 use stochy_resol_def, only : skeblevs,levs,jcap,lonf,latg
 use stochy_namelist_def
 use constants_mod, only : radius
 use spectral_layout_mod, only : me, nodes
 use mpi_wrapper, only: mp_bcst, is_master
 use stochy_patterngenerator_mod, only: random_pattern, patterngenerator_init,&
 getnoise, patterngenerator_advance,ndimspec,chgres_pattern,computevarspec_r
 use initialize_spectral_mod, only: initialize_spectral
 use stochy_internal_state_mod
! use mersenne_twister_stochy, only : random_seed
 use mersenne_twister, only : random_seed
 use compns_stochy_mod, only : compns_stochy

 implicit none
 private
 public :: init_stochdata

 type(random_pattern), public, save, allocatable, dimension(:) :: &
       rpattern_sppt,rpattern_shum,rpattern_skeb, rpattern_sfc
 integer, public :: nsppt=0
 integer, public :: nshum=0
 integer, public :: nskeb=0
 integer, public :: npsfc=0
 real*8, public,allocatable :: sl(:)

 real(kind=kind_dbl_prec),public, allocatable :: vfact_sppt(:),vfact_shum(:),vfact_skeb(:)
 real(kind=kind_dbl_prec),public, allocatable :: skeb_vwts(:,:),skeb_vpts(:,:)
 real(kind=kind_dbl_prec),public, allocatable :: gg_lats(:),gg_lons(:)
 real(kind=kind_dbl_prec),public :: wlon,rnlat,rad2deg
 real(kind=kind_dbl_prec),public, allocatable :: skebu_save(:,:,:),skebv_save(:,:,:)
 integer,public :: INTTYP
 type(stochy_internal_state),public :: gis_stochy

 contains
!>@brief The subroutine 'init_stochdata' determins which stochastic physics
!!pattern genertors are needed.
!>@details it reads the nam_stochy namelist and allocates necessary arrays
 subroutine init_stochdata(nlevs,delt,input_nml_file,fn_nml,nlunit,iret)
!\callgraph

! initialize random patterns.  A spinup period of spinup_efolds times the
! temporal time scale is run for each pattern.
   integer, intent(in) :: nlunit,nlevs
   character(len=*),  intent(in) :: input_nml_file(:)
   character(len=64), intent(in) :: fn_nml
   real, intent(in) :: delt
   integer, intent(out) :: iret
   real :: pertsfc(1)

   real :: rnn1
   integer :: nn,nspinup,k,nm,spinup_efolds,stochlun,ierr,n
   integer :: locl,indev,indod,indlsod,indlsev
   integer :: l,jbasev,jbasod
   real(kind_dbl_prec),allocatable :: noise_e(:,:),noise_o(:,:)
   include 'function_indlsod'
   include 'function_indlsev'
   stochlun=99
   levs=nlevs

   iret=0
! read in namelist
   call compns_stochy (me,size(input_nml_file,1),input_nml_file(:),fn_nml,nlunit,delt,iret)
   if(is_master()) print*,'in init stochdata',nodes,lat_s
   if ( (.NOT. do_sppt) .AND. (.NOT. do_shum) .AND. (.NOT. do_skeb)  .AND. (.NOT. do_sfcperts) ) return
! initialize the specratl pattern generatore (including gaussian grid decomposition)
!   if (nodes.GE.lat_s/2) then
!      lat_s=(int(nodes/12)+1)*24
!      lon_s=lat_s*2
!      ntrunc=lat_s-2
!      if (is_master()) print*,'WARNING: spectral resolution is too low for number of mpi_tasks, resetting lon_s,lat_s,and ntrunc to',lon_s,lat_s,ntrunc
!   endif

   call initialize_spectral(gis_stochy, iret)
   if (iret/=0) return
   allocate(noise_e(len_trie_ls,2),noise_o(len_trio_ls,2))
! determine number of random patterns to be used for each scheme.
   do n=1,size(sppt)
     if (sppt(n) > 0) then
        nsppt=nsppt+1
     else
        exit
     endif
   enddo
   if (is_master()) print *,'nsppt = ',nsppt
   do n=1,size(shum)
     if (shum(n) > 0) then
        nshum=nshum+1
     else
        exit
     endif
   enddo
   if (is_master()) print *,'nshum = ',nshum
   do n=1,size(skeb)
     if (skeb(n) > 0) then
        nskeb=nskeb+1
     else
        exit
     endif
   enddo
   if (is_master()) print *,'nskeb = ',nskeb
   ! mg, sfc-perts
   do n=1,size(pertz0)
     if (pertz0(n) > 0 .or. pertzt(n)>0 .or. pertshc(n)>0 .or. &
         pertvegf(n)>0 .or. pertlai(n)>0 .or. pertalb(n)>0) then
        npsfc=npsfc+1
     else
        exit
     endif
   enddo
   if (is_master()) then
     if (npsfc > 0) then
       print *,' npsfc   = ', npsfc
       print *,' pertz0  = ', pertz0
       print *,' pertzt  = ', pertzt
       print *,' pertshc = ', pertshc
       print *,' pertlai = ', pertlai
       print *,' pertalb = ', pertalb
       print *,' pertvegf = ', pertvegf
     endif
   endif

   if (nsppt > 0) allocate(rpattern_sppt(nsppt))
   if (nshum > 0) allocate(rpattern_shum(nshum))
   if (nskeb > 0) allocate(rpattern_skeb(nskeb))
   ! mg, sfc perts
   if (npsfc > 0) allocate(rpattern_sfc(npsfc))

!  if stochini is true, then read in pattern from a file
   if (is_master()) then
      if (stochini) then
         print*,'opening stoch_ini'
         OPEN(stochlun,file='stoch_ini',form='unformatted',iostat=ierr,status='old')
         if (ierr .NE. 0) then
            write(0,*) 'error opening stoch_ini'
            iret = ierr
            return
         end if
      endif
   endif
   ! no spinup needed if initial patterns are defined correctly.
   spinup_efolds = 0
   if (nsppt > 0) then
       if (is_master()) print *, 'Initialize random pattern for SPPT'
       call patterngenerator_init(sppt_lscale,spptint,sppt_tau,sppt,iseed_sppt,rpattern_sppt, &
           lonf,latg,jcap,gis_stochy%ls_node,nsppt,1,0,new_lscale)
       do n=1,nsppt
          nspinup = spinup_efolds*sppt_tau(n)/spptint
          if (stochini) then
             call read_pattern(rpattern_sppt(n),1,stochlun)
          else
             call getnoise(rpattern_sppt(n),noise_e,noise_o)
             do nn=1,len_trie_ls
                rpattern_sppt(n)%spec_e(nn,1,1)=noise_e(nn,1)
                rpattern_sppt(n)%spec_e(nn,2,1)=noise_e(nn,2)
                nm = rpattern_sppt(n)%idx_e(nn)
                if (nm .eq. 0) cycle
                rpattern_sppt(n)%spec_e(nn,1,1) = rpattern_sppt(n)%stdev*rpattern_sppt(n)%spec_e(nn,1,1)*rpattern_sppt(n)%varspectrum(nm)
                rpattern_sppt(n)%spec_e(nn,2,1) = rpattern_sppt(n)%stdev*rpattern_sppt(n)%spec_e(nn,2,1)*rpattern_sppt(n)%varspectrum(nm)
             enddo
             do nn=1,len_trio_ls
                rpattern_sppt(n)%spec_o(nn,1,1)=noise_o(nn,1)
                rpattern_sppt(n)%spec_o(nn,2,1)=noise_o(nn,2)
                nm = rpattern_sppt(n)%idx_o(nn)
                if (nm .eq. 0) cycle
                rpattern_sppt(n)%spec_o(nn,1,1) = rpattern_sppt(n)%stdev*rpattern_sppt(n)%spec_o(nn,1,1)*rpattern_sppt(n)%varspectrum(nm)
                rpattern_sppt(n)%spec_o(nn,2,1) = rpattern_sppt(n)%stdev*rpattern_sppt(n)%spec_o(nn,2,1)*rpattern_sppt(n)%varspectrum(nm)
             enddo
             do nn=1,nspinup
                call patterngenerator_advance(rpattern_sppt(n),1,.false.)
             enddo
          endif
       enddo
   endif
   if (nshum > 0) then
       if (is_master()) print *, 'Initialize random pattern for SHUM'
       call patterngenerator_init(shum_lscale,shumint,shum_tau,shum,iseed_shum,rpattern_shum, &
           lonf,latg,jcap,gis_stochy%ls_node,nshum,1,0,new_lscale)
       do n=1,nshum
          nspinup = spinup_efolds*shum_tau(n)/shumint
          if (stochini) then
             call read_pattern(rpattern_shum(n),1,stochlun)
          else
             call getnoise(rpattern_shum(n),noise_e,noise_o)
             do nn=1,len_trie_ls
                rpattern_shum(n)%spec_e(nn,1,1)=noise_e(nn,1)
                rpattern_shum(n)%spec_e(nn,2,1)=noise_e(nn,2)
                nm = rpattern_shum(n)%idx_e(nn)
                if (nm .eq. 0) cycle
                rpattern_shum(n)%spec_e(nn,1,1) = rpattern_shum(n)%stdev*rpattern_shum(n)%spec_e(nn,1,1)*rpattern_shum(n)%varspectrum(nm)
                rpattern_shum(n)%spec_e(nn,2,1) = rpattern_shum(n)%stdev*rpattern_shum(n)%spec_e(nn,2,1)*rpattern_shum(n)%varspectrum(nm)
             enddo
             do nn=1,len_trio_ls
                rpattern_shum(n)%spec_o(nn,1,1)=noise_o(nn,1)
                rpattern_shum(n)%spec_o(nn,2,1)=noise_o(nn,2)
                nm = rpattern_shum(n)%idx_o(nn)
                if (nm .eq. 0) cycle
                rpattern_shum(n)%spec_o(nn,1,1) = rpattern_shum(n)%stdev*rpattern_shum(n)%spec_o(nn,1,1)*rpattern_shum(n)%varspectrum(nm)
                rpattern_shum(n)%spec_o(nn,2,1) = rpattern_shum(n)%stdev*rpattern_shum(n)%spec_o(nn,2,1)*rpattern_shum(n)%varspectrum(nm)
             enddo
             do nn=1,nspinup
                call patterngenerator_advance(rpattern_shum(n),1,.false.)
             enddo
          endif
       enddo
   endif

   if (nskeb > 0) then
  ! determine number of skeb levels to deal with temperoal/vertical correlations
   skeblevs=nint(skeb_tau(1)/skebint*skeb_vdof)
! backscatter noise.
       if (is_master()) print *, 'Initialize random pattern for SKEB',skeblevs
       call patterngenerator_init(skeb_lscale,skebint,skeb_tau,skeb,iseed_skeb,rpattern_skeb, &
           lonf,latg,jcap,gis_stochy%ls_node,nskeb,skeblevs,skeb_varspect_opt,new_lscale)
       do n=1,nskeb
          do k=1,skeblevs
             nspinup = spinup_efolds*skeb_tau(n)/skebint
             if (stochini) then
                call read_pattern(rpattern_skeb(n),k,stochlun)
                if (is_master()) print *, 'skeb read',k,rpattern_skeb(n)%spec_o(5,1,k)
             else
                call getnoise(rpattern_skeb(n),noise_e,noise_o)
                do nn=1,len_trie_ls
                   rpattern_skeb(n)%spec_e(nn,1,k)=noise_e(nn,1)
                   rpattern_skeb(n)%spec_e(nn,2,k)=noise_e(nn,2)
                   nm = rpattern_skeb(n)%idx_e(nn)
                   if (nm .eq. 0) cycle
                   rpattern_skeb(n)%spec_e(nn,1,k) = rpattern_skeb(n)%stdev*rpattern_skeb(n)%spec_e(nn,1,k)*rpattern_skeb(n)%varspectrum(nm)
                   rpattern_skeb(n)%spec_e(nn,2,k) = rpattern_skeb(n)%stdev*rpattern_skeb(n)%spec_e(nn,2,k)*rpattern_skeb(n)%varspectrum(nm)
                enddo
                do nn=1,len_trio_ls
                   rpattern_skeb(n)%spec_o(nn,1,k)=noise_o(nn,1)
                   rpattern_skeb(n)%spec_o(nn,2,k)=noise_o(nn,2)
                   nm = rpattern_skeb(n)%idx_o(nn)
                   if (nm .eq. 0) cycle
                   rpattern_skeb(n)%spec_o(nn,1,k) = rpattern_skeb(n)%stdev*rpattern_skeb(n)%spec_o(nn,1,k)*rpattern_skeb(n)%varspectrum(nm)
                   rpattern_skeb(n)%spec_o(nn,2,k) = rpattern_skeb(n)%stdev*rpattern_skeb(n)%spec_o(nn,2,k)*rpattern_skeb(n)%varspectrum(nm)
                enddo
             endif
          enddo
          do nn=1,nspinup
             call patterngenerator_advance(rpattern_skeb(n),skeblevs,.false.)
          enddo
       enddo

    gis_stochy%kenorm_e=1.
    gis_stochy%kenorm_o=1. ! used to convert forcing pattern to wind field.
if (skebnorm==0) then
 do locl=1,ls_max_node
     l = gis_stochy%ls_node(locl)
     jbasev = gis_stochy%ls_node(locl+ls_dim)
     indev = indlsev(l,l)
     jbasod = gis_stochy%ls_node(locl+2*ls_dim)
     indod = indlsod(l+1,l)
     do n=l,jcap,2
        rnn1 = n*(n+1.)
        gis_stochy%kenorm_e(indev) = rnn1/radius**2
        indev = indev + 1
     enddo
     do n=l+1,jcap,2
        rnn1 = n*(n+1.)
        gis_stochy%kenorm_o(indod) = rnn1/radius**2
        indod = indod + 1
     enddo
  enddo
  if (is_master()) print*,'using streamfunction ',maxval(gis_stochy%kenorm_e(:)),minval(gis_stochy%kenorm_e(:))
endif
if (skebnorm==1) then
 do locl=1,ls_max_node
     l = gis_stochy%ls_node(locl)
     jbasev = gis_stochy%ls_node(locl+ls_dim)
     indev = indlsev(l,l)
     jbasod = gis_stochy%ls_node(locl+2*ls_dim)
     indod = indlsod(l+1,l)
     do n=l,jcap,2
        rnn1 = n*(n+1.)
        gis_stochy%kenorm_e(indev) = sqrt(rnn1)/radius
        indev = indev + 1
     enddo
     do n=l+1,jcap,2
        rnn1 = n*(n+1.)
        gis_stochy%kenorm_o(indod) = sqrt(rnn1)/radius
        indod = indod + 1
     enddo
  enddo
  if (is_master()) print*,'using kenorm ',maxval(gis_stochy%kenorm_e(:)),minval(gis_stochy%kenorm_e(:))
endif
  ! set the even and odd (n-l) terms of the top row to zero
do locl=1,ls_max_node
   l = gis_stochy%ls_node(locl)
   jbasev = gis_stochy%ls_node(locl+ls_dim)
   jbasod = gis_stochy%ls_node(locl+2*ls_dim)
   if (mod(l,2) .eq. mod(jcap+1,2)) then
      gis_stochy%kenorm_e(indlsev(jcap+1,l)) = 0.
   endif
   if (mod(l,2) .ne. mod(jcap+1,2)) then
      gis_stochy%kenorm_o(indlsod(jcap+1,l)) = 0.
   endif
enddo

   endif ! skeb > 0
! mg, sfc-perts
if (npsfc > 0) then
       pertsfc(1) = 1.
       call patterngenerator_init(sfc_lscale,delt,sfc_tau,pertsfc,iseed_sfc,rpattern_sfc, &
              lonf,latg,jcap,gis_stochy%ls_node,npsfc,nsfcpert,0,new_lscale)
       do n=1,npsfc
          if (is_master()) print *, 'Initialize random pattern for SFC-PERTS',n
          do k=1,nsfcpert
           nspinup = spinup_efolds*sfc_tau(n)/delt
           call getnoise(rpattern_sfc(n),noise_e,noise_o)
           do nn=1,len_trie_ls
              rpattern_sfc(n)%spec_e(nn,1,k)=noise_e(nn,1)
              rpattern_sfc(n)%spec_e(nn,2,k)=noise_e(nn,2)
              nm = rpattern_sfc(n)%idx_e(nn)
              if (nm .eq. 0) cycle
              rpattern_sfc(n)%spec_e(nn,1,k) = rpattern_sfc(n)%stdev*rpattern_sfc(n)%spec_e(nn,1,k)*rpattern_sfc(n)%varspectrum(nm)
              rpattern_sfc(n)%spec_e(nn,2,k) = rpattern_sfc(n)%stdev*rpattern_sfc(n)%spec_e(nn,2,k)*rpattern_sfc(n)%varspectrum(nm)
           enddo
           do nn=1,len_trio_ls
              rpattern_sfc(n)%spec_o(nn,1,k)=noise_o(nn,1)
              rpattern_sfc(n)%spec_o(nn,2,k)=noise_o(nn,2)
              nm = rpattern_sfc(n)%idx_o(nn)
              if (nm .eq. 0) cycle
              rpattern_sfc(n)%spec_o(nn,1,k) = rpattern_sfc(n)%stdev*rpattern_sfc(n)%spec_o(nn,1,k)*rpattern_sfc(n)%varspectrum(nm)
              rpattern_sfc(n)%spec_o(nn,2,k) = rpattern_sfc(n)%stdev*rpattern_sfc(n)%spec_o(nn,2,k)*rpattern_sfc(n)%varspectrum(nm)
           enddo
           do nn=1,nspinup
              call patterngenerator_advance(rpattern_sfc(n),k,.false.)
           enddo
           if (is_master()) print *, 'Random pattern for SFC-PERTS: k, min, max ',k, minval(rpattern_sfc(1)%spec_o(:,:,k)), maxval(rpattern_sfc(1)%spec_o(:,:,k))
         enddo ! k, nsfcpert
       enddo ! n, npsfc
   endif ! npsfc > 0
   if (is_master() .and. stochini) CLOSE(stochlun)
   deallocate(noise_e,noise_o)
 end subroutine init_stochdata
!>@brief This subroutine 'read_pattern' will read in the spectral coeffients from a previous run (stored in stoch_ini,
!!turned on by setting STOCHINI=.true.)
!>@details Data read in are flat binary, so the number of stochastic physics patterns running must match previous run
subroutine read_pattern(rpattern,k,lunptn)
!\callgraph
   type(random_pattern), intent(inout) :: rpattern
   integer, intent(in) :: lunptn
   real(kind_dbl_prec),allocatable  :: pattern2d(:),pattern2din(:)
   real(kind_dbl_prec) :: stdevin,varin
   integer nm,nn,ierr,jcap,isize,k
   integer, allocatable :: isave(:)

   allocate(pattern2d(2*ndimspec))
   pattern2d=0.
   call random_seed(size=isize,stat=rpattern%rstate)  ! get size of generator state seed array
   allocate(isave(isize))
   ! read only on root process, and send to all tasks
   if (is_master()) then
      read(lunptn) jcap
      read(lunptn) isave
      allocate(pattern2din((jcap+1)*(jcap+2)))
      print*,'reading in random pattern at ',jcap,ndimspec,size(pattern2din)
      read(lunptn) pattern2din
      print*,'reading in random pattern (min/max/size/seed)',&
      minval(pattern2din),maxval(pattern2din),size(pattern2din),isave(1:4)
      if (jcap .eq. ntrunc) then
         pattern2d=pattern2din
      else
         call chgres_pattern(pattern2din,pattern2d,jcap,ntrunc) ! chgres of spectral files
         ! change the standard deviation of the patterns for a resolution change
         ! needed for SKEB & SHUM
         call computevarspec_r(rpattern,pattern2d,varin)
         print*,'stddev in and out..',sqrt(varin),rpattern%stdev
         stdevin=rpattern%stdev/sqrt(varin)
         pattern2d(:)=pattern2d(:)*stdevin
      endif
      deallocate(pattern2din)
    endif
    call mp_bcst(isave,isize)  ! blast out seed
    call mp_bcst(pattern2d,2*ndimspec)
    call random_seed(put=isave,stat=rpattern%rstate)
   ! subset
   do nn=1,len_trie_ls
      nm = rpattern%idx_e(nn)
      if (nm == 0) cycle
      rpattern%spec_e(nn,1,k) = pattern2d(nm)
      rpattern%spec_e(nn,2,k) = pattern2d(ndimspec+nm)
   enddo
   do nn=1,len_trio_ls
      nm = rpattern%idx_o(nn)
      if (nm == 0) cycle
      rpattern%spec_o(nn,1,k) = pattern2d(nm)
      rpattern%spec_o(nn,2,k) = pattern2d(ndimspec+nm)
   enddo
   !print*,'after scatter...',me,maxval(pattern2d_e),maxval(pattern2d_o) &
   ! ,minval(pattern2d_e),minval(pattern2d_o)
   deallocate(pattern2d,isave)
 end subroutine read_pattern

end module stochy_data_mod
