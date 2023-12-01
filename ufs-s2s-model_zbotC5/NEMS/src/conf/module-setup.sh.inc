# Create a test function for sh vs. bash detection.  The name is
# randomly generated to reduce the chances of name collision.
__ms_function_name="setup__test_function__$$"
eval "$__ms_function_name() { /bin/true ; }"

# Determine which shell we are using
__ms_ksh_test=$( eval '__text="text" ; if [[ $__text =~ ^(t).* ]] ; then printf "%s" ${.sh.match[1]} ; fi' 2> /dev/null | cat )
__ms_bash_test=$( eval 'if ( set | grep '$__ms_function_name' | grep -v name > /dev/null 2>&1 ) ; then echo t ; fi ' 2> /dev/null | cat )

if [[ ! -z "$__ms_ksh_test" ]] ; then
    __ms_shell=ksh
elif [[ ! -z "$__ms_bash_test" ]] ; then
    __ms_shell=bash
else
    # Not bash or ksh, so assume sh.
    __ms_shell=sh
fi

if [[ -d /lfs3 ]] ; then
    # We are on NOAA Jet
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source /apps/lmod/lmod/init/$__ms_shell
    fi
    module purge
elif [[ -d /scratch1 && ! -d /scratch ]] ; then
    # We are on NOAA Hera
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source /apps/lmod/lmod/init/$__ms_shell
    fi
    module purge
elif [[ -d /scratch3 && -d /scratch ]] ; then
    # We are on NOAA Theia
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source /apps/lmod/lmod/init/$__ms_shell
    fi
    module purge
elif [[ -d /gpfs/hps && -e /etc/SuSE-release ]] ; then
    # We are on NOAA Luna or Surge
    if ( ! eval module help > /dev/null 2>&1 ) ; then
       source /opt/modules/default/init/$__ms_shell
    fi
    module purge
    module purge
    # Workaround until module issues are fixed:
    unset _LMFILES_
    unset LOADEDMODULES
    module use /opt/modulefiles
    module use /opt/cray/ari/modulefiles
    module use /opt/cray/craype/default/alt-modulefiles
    module use /opt/cray/alt-modulefiles
    module use /gpfs/hps/nco/ops/nwprod/modulefiles
    module use /gpfs/hps/nco/ops/nwprod/lib/modulefiles
    module use /usrx/local/prod/modulefiles
elif [[ -d /dcom && -d /hwrf ]] ; then
    # We are on NOAA Tide or Gyre
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source /usrx/local/Modules/default/init/$__ms_shell
    fi
    module purge
elif [[ -L /usrx && "$( readlink /usrx 2> /dev/null )" =~ dell ]] ; then
    # We are on NOAA Mars or Venus
    if ( ! eval module help > /dev/null 2>&1 ) ; then
	source /usrx/local/prod/lmod/lmod/init/$__ms_shell
    fi
    module purge
elif [[ -d /glade ]] ; then
    # We are on NCAR Cheyenne   
    if ( ! eval module help > /dev/null 2>&1 ) ; then
      . /glade/u/apps/ch/modulefiles/default/localinit/localinit.sh
    fi
    module purge
elif [[ -d /lustre && -d /ncrc ]] ; then
    # We are on GAEA. 
#        # We cannot simply load the module command.  The GAEA
#        # /etc/profile modifies a number of module-related variables
#        # before loading the module command.  Without those variables,
#        # the module command fails.  Hence we actually have to source
#        # /etc/profile here.
        source /opt/cray/pe/modules/3.2.11.4/init/bash
        __ms_source_etc_profile=yes
    target=gaea
    module purge
# clean up after purge 
    unset _LMFILES_
    unset _LMFILES_000
    unset _LMFILES_001
    unset LOADEDMODULES
    module load modules
    module use /opt/cray/ari/modulefiles
    module use /opt/cray/pe/craype/2.6.3/modulefiles
    module use /opt/modulefiles
    source /etc/opt/cray/pe/admin-pe/site-config
    module use /sw/gaea-cle7/modulefiles/linux-sles15-x86_64
    module load globus/default
    module load globus-toolkit/6.0.17
    module load cmake/3.17.0
    module load craype-network-aries
    module load craype-broadwell
    module use /opt/cray/pe/modulefiles
    module load modules
    module load craype/2.6.3
    module load cray-mpich
    module load pmi
    module unload PrgEnv-intel PrgEnv-cce PrgEnv-gnu PrgEnv-pgi

    module use /sw/gaea/modulefiles
    module load python/2.7.12
    module load CmrsEnv
    module load TimeZoneEDT

    module unload intel
    module load intel/19.0.5.281
    module load dvs/2.12_2.2.164-7.0.2.1_3.8__g1afc88eb
    module load xpmem/2.2.20-7.0.2.1_2.15__g87eb960.ari
    module load alps
    module load udreg
    module load ugni
    module load dmapp
    module load gni-headers
    module load job
    module load rca
    module load PrgEnv-intel/6.0.5
    module load intel/19.0.5.281
    export NCEPLIBS=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib
    module use ${NCEPLIBS}/modulefiles
    module load netcdfp/4.7.4
    module load bacio-intel-sandybridge/2.0.2
    module load crtm-intel-sandybridge/2.3.0
    module load g2-intel-sandybridge/3.1.0
    module load g2tmpl-intel-sandybridge/1.5.0
    module load ip-intel/3.0.0
    module load sp-intel-sandybridge/2.0.2
    module load w3nco-intel-sandybridge/2.0.6
    module load w3emc-intel-sandybridge/2.3.0
    module load nemsio-intel-sandybridge/2.2.4
    module load gfsio-intel-sandybridge/1.1.0
    module load sfcio-intel-sandybridge/1.0.0
    module load sigio-intel-sandybridge/2.1.0

    module load post-intel-sandybridge/8.0.5
    export HDF5_DIR=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export HDF5_ROOT=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export HDF5=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp/lib/libhdf5.a
    export NETCDF_DIR=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export NETCDF_ROOT=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export NETCDF_PATH=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export NetCDF_INCLUDE_DIRS=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp/include
    export NetCDF_VERSION=4.7.4
    export NetCDF_PARALLEL=F

    export NetCDF=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp
    export NETCDF4=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp

    export ESMF_NETCDF=split
    export ESMF_NETCDF_INCLUDE=${NetCDF_INCLUDE_DIRS}
    export ESMF_NETCDF_LIBPATH=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib/netcdfp/lib

    export DARSHAN_LIB_PATH=/sw/gaea-cle7/darshan/3.2.1-1/runtime/lib
    export DARSHAN_SHARE_PATH=/sw/gaea-cle7/darshan/3.2.1-1/runtime/share

    export POST_SRC=$NCEPLIBS/gfs_post.fd/v8.0.5/src
    export POST_INC=$NCEPLIBS/gfs_post.fd/v8.0.5/intel/include/ncep_post_4
    export POST_LIB=$NCEPLIBS/gfs_post.fd/v8.0.5/intel/libncep_post_4.a

    module load jasper-intel-sandybridge/1.900.1
    module load png-intel-sandybridge/1.2.44
    module load zlib-intel-sandybridge/1.2.7



    if [[ "$__ms_source_etc_profile" == yes ]] ; then
      unset __ms_source_etc_profile
      source /opt/cray/pe/modules/3.2.11.4/init/bash
    fi
    module use /lustre/f2/pdata/ncep/Weiyu.Yang/ncep_shared/emc.nemspara/soft/modulefiles
    module load rocoto/1.3.1_new

elif [[ -d /lrz/sys ]] ; then
    # We are on LRZ SuperMUC, nothing to do
    echo "Platform: LRZ SuperMUC"
elif [[ -d /Applications ]] ; then
    # We are on a MacOSX system, nothing to do
    echo "Platform: MacOSX"
elif [[ -e /etc/redhat-release ]] ; then
    if grep -iq centos "/etc/redhat-release" ; then
        # We are on CentOS Linux, nothing to do
        echo "Platform: CentOS Linux"
    else
        echo WARNING: UNKNOWN PLATFORM 1>&2
    fi
elif [[ -e /etc/issue ]] ; then
    if grep -iq ubuntu "/etc/issue" ; then
        # We are on Ubuntu Linux, nothing to do
        echo "Platform: Ubuntu Linux"
    else
        echo WARNING: UNKNOWN PLATFORM 1>&2
    fi
else
    echo WARNING: UNKNOWN PLATFORM 1>&2
fi

module load git/2.9.3
module use /sw/common/modulefiles
module load DefApps
module list
unset __ms_shell
unset __ms_ksh_test
unset __ms_bash_test
unset $__ms_function_name
unset __ms_function_name
