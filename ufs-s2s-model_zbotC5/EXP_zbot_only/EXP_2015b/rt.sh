#!/bin/bash
set -eux

SECONDS=0

hostname

die() { echo "$@" >&2; exit 1; }
usage() {
  set +x
  echo
  echo "Usage: $0 -c <model> | -f | -s | -l <file> | -m | -k | -r | -e | -h"
  echo
  echo "  -c  create new baseline results for <model>"
  echo "  -f  run full suite of regression tests"
  echo "  -s  run standard suite of regression tests"
  echo "  -l  runs test specified in <file>"
  echo "  -m  compare against new baseline results"
  echo "  -k  keep run directory"
  echo "  -r  use Rocoto workflow manager"
  echo "  -e  use ecFlow workflow manager"
  echo "  -h  display this help"
  echo
  set -x
  exit 1
}

[[ $# -eq 0 ]] && usage

rt_single() {
  local compile_line=''
  local run_line=''
  while read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"
    [[ ${#line} == 0 ]] && continue
    [[ $line == \#* ]] && continue

    if [[ $line =~ COMPILE && $line =~ ${MACHINE_ID} ]]; then
      compile_line=$line
    fi

    if [[ $line =~ RUN ]]; then
      tmp_test=$(echo $line | cut -d'|' -f2 | sed -e 's/^ *//' -e 's/ *$//')
      if [[ $SINGLE_NAME == $tmp_test && $compile_line != '' ]]; then
        echo $compile_line >$TESTS_FILE
        echo $line >>$TESTS_FILE
        break
      fi
    fi
  done <'rt.conf'

  if [[ ! -f $TESTS_FILE ]]; then
    echo "$SINGLE_NAME does not exist or cannot be run on $MACHINE_ID"
    exit 1
  fi
}

rt_3mo() {
  local NWPROD=/lustre/f2/dev/ncep/JieShun.Zhu/CFSmisc
  local nhour=$NWPROD/common/nhour
  local nday=$NWPROD/common/nday
  local nextmonth=$NWPROD/common/nextmonth.sh

  local sy=$(echo ${DATE_3mo} | cut -c 1-4)
  local sm=$(echo ${DATE_3mo} | cut -c 5-6)
  local sd=$(echo ${DATE_3mo} | cut -c 7-8)
  local new_test_name="tests/${TEST_NAME}_${DATE_3mo}"
  rm -f tests/$new_test_name
  cp tests/$TEST_NAME $new_test_name

  local nmons=0
  local nmonsP=0
  if [[ $TEST_NAME =~ 3mo$ ]]; then
	  local nmons=2
	  local nmonsP=0
  elif [[ $TEST_NAME =~ 3moR1$ ]]; then
          local nmons=6 
          local nmonsP=2
  elif [[ $TEST_NAME =~ 3moR2$ ]]; then 
	  local nmons=10
	  local nmonsP=6
  fi

  local yyyymmP=$sy$sm
  local im=1
  until [ $im -gt $nmonsP ] ; do
    local yyyymmP=`$nextmonth ${yyyymmP}`
    local im=`expr $im + 1`
  done

  local yyyymm=$sy$sm
  local im=1
  until [ $im -gt $nmons ] ; do
    local yyyymm=`$nextmonth ${yyyymm}`
    local im=`expr $im + 1`
  done

  local CDATEp=${yyyymmP}0100
  local CDATEed=${yyyymm}0100
  local numdays=`$nday $CDATEed $DATE_3mo`
  local numFHMAX=`nhour $CDATEed $DATE_3mo`
  local numWLCLK=900
  local fhrot=`nhour $CDATEp $DATE_3mo`
  local rstITV=`nhour $CDATEed $CDATEp`

  if [[ $TEST_NAME =~ cold$ ]]; then
    sed -i -e "s/\(export LIST_FILES\)/\1=\"ufs.s2s.cold.cpl.r.${sy}-${sm}-${sd}-03600.nc\"/" $new_test_name
    sed -i -e "s/\(export SYEAR\)/\1=\"$sy\"/" $new_test_name
    sed -i -e "s/\(export SMONTH\)/\1=\"$sm\"/" $new_test_name
    sed -i -e "s/\(export SDAY\)/\1=\"$sd\"/" $new_test_name
    if [[ $TEST_NAME =~ ww3 ]]; then
      sed -i -e "s/\(export CNTL_DIR\)/\1='RT-Baselines_cold_bmwav_cmeps_${DATE_3mo}'/" $new_test_name
      sed -i -e "s/\(export CNTLMED_DIR\)/\1='MEDIATOR_bmwav_cmeps_${DATE_3mo}'/" $new_test_name
    else
#      sed -i -e "s/\(export CNTL_DIR\)/\1='RT-Baselines_cold_bm_cmeps_${DATE_3mo}'/" $new_test_name
#      sed -i -e "s/\(export CNTLMED_DIR\)/\1='MEDIATOR_bm_cmeps_${DATE_3mo}'/" $new_test_name
      sed -i -e "s/\(export CNTL_DIR\)/\1='RT-Baselines_cold_ccpp_cmeps_${DATE_3mo}'/" $new_test_name
      sed -i -e "s/\(export CNTLMED_DIR\)/\1='MEDIATOR_ccpp_cmeps_${DATE_3mo}'/" $new_test_name
    fi
  elif [[ $TEST_NAME = *3mo* ]]; then
    sed -i -e "s/\(export SYEAR\)/\1=\"$sy\"/" $new_test_name
    sed -i -e "s/\(export SMONTH\)/\1=\"$sm\"/" $new_test_name
    sed -i -e "s/\(export SDAY\)/\1=\"$sd\"/" $new_test_name
    sed -i -e "s/\(export DAYS\)/\1=\"$numdays\"/" $new_test_name
    sed -i -e "s/\(export FHMAX\)/\1=\"$numFHMAX\"/" $new_test_name
    sed -i -e "s/\(export WLCLK\)/\1=\"$numWLCLK\"/" $new_test_name
    DEP_RUN=${DEP_RUN}_${DATE_3mo}
    if [[ $TEST_NAME =~ ww3 ]]; then
      sed -i -e "s/\(export MED_restart_data\)/\1='MEDIATOR_bmwav_cmeps_${DATE_3mo}'/" $new_test_name
    else
     sed -i -e "s/\(export MED_restart_data\)/\1='MEDIATOR_ccpp_cmeps_${DATE_3mo}'/" $new_test_name
#      sed -i -e "s/\(export MED_restart_data\)/\1='MEDIATOR_bm_cmeps_${DATE_3mo}'/" $new_test_name
    fi
    if [[ $TEST_NAME = *3moR* ]]; then
      sed -i -e "s/\(export FHROT\)/\1=\"${fhrot}\"/" $new_test_name
      sed -i -e "s/\(export FV3_RESTART_INTERVAL\)/\1=\"${rstITV}\"/" $new_test_name
      sed -i -e "s/\(export FHrstMAX\)/\1=\"${rstITV}\"/" $new_test_name
    fi
  fi

  TEST_NAME=${new_test_name#tests/}
}

rt_trap() {
  [[ ${ROCOTO:-false} == true ]] && rocoto_kill
  cleanup
}

cleanup() {
  [[ ${ECFLOW:-false} == true ]] && ecflow_stop
  rm -rf ${LOCKDIR}
  trap 0
  exit
}

trap '{ echo "rt.sh interrupted"; rt_trap ; }' INT
trap '{ echo "rt.sh quit"; rt_trap ; }' QUIT
trap '{ echo "rt.sh terminated"; rt_trap ; }' TERM
trap '{ echo "rt.sh error on line $LINENO"; rt_trap ; }' ERR
trap '{ echo "rt.sh finished"; cleanup ; }' EXIT

# PATHRT - Path to regression tests directory
readonly PATHRT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
cd ${PATHRT}

# PATHTR - Path to nmmb trunk directory
readonly PATHTR=$( cd ${PATHRT}/.. && pwd )

# make sure only one instance of rt.sh is running
readonly LOCKDIR="${PATHRT}"/lock
if mkdir "${LOCKDIR}" ; then
  echo $(hostname) $$ > "${LOCKDIR}/PID"
else
  echo "Only one instance of rt.sh can be running at a time"
  exit 1
fi

# Default compiler "intel"
export COMPILER=${NEMS_COMPILER:-intel}

source detect_machine.sh
source rt_utils.sh

if [[ $MACHINE_ID = wcoss_cray ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc
  module load xt-lsfhpc

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3

  module load python/2.7.14

  module use /usrx/local/emc_rocoto/modulefiles
  module load rocoto/1.3.0rc2
  ROCOTORUN=$(which rocotorun)
  ROCOTOSTAT=$(which rocotostat)
  ROCOTOCOMPLETE=$(which rocotocomplete)

  module load ecflow/intel/4.7.1
  ECFLOW_START=${ECF_ROOT}/intel/bin/ecflow_start.sh
  ECF_PORT=$(grep $USER /usrx/local/sys/ecflow/assigned_ports.txt | awk '{print $2}')

  DISKNM=/gpfs/hps3/emc/nems/noscrub/emc.nemspara/RT
  QUEUE=debug
  PARTITION=
  ACCNR=GFS-DEV
  if [[ -d /gpfs/hps3/ptmp ]] ; then
      STMP=/gpfs/hps3/stmp
      PTMP=/gpfs/hps3/stmp
  else
      STMP=/gpfs/hps3/stmp
      PTMP=/gpfs/hps3/ptmp
  fi
  SCHEDULER=lsf
  cp fv3_conf/fv3_bsub.IN_wcoss_cray fv3_conf/fv3_bsub.IN

elif [[ $MACHINE_ID = wcoss_dell_p3 ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc
  module load lsf/10.1

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3

  module load python/2.7.14

  module use /usrx/local/dev/emc_rocoto/modulefiles
  module load ruby/2.5.1 rocoto/1.3.0rc2
  ROCOTORUN=$(which rocotorun)
  ROCOTOSTAT=$(which rocotostat)
  ROCOTOCOMPLETE=$(which rocotocomplete)

  module load ips/18.0.1.163
  module load ecflow/4.7.1
  ECFLOW_START=${ECF_ROOT}/intel/bin/ecflow_start.sh
  ECF_PORT=$(grep $USER /usrx/local/sys/ecflow/assigned_ports.txt | awk '{print $2}')

  DISKNM=/gpfs/dell2/emc/modeling/noscrub/emc.nemspara/RT
  QUEUE=dev
  PARTITION=
  ACCNR=GFS-DEV
  STMP=/gpfs/dell2/stmp
  PTMP=/gpfs/dell2/ptmp
  SCHEDULER=lsf
  cp fv3_conf/fv3_bsub.IN_wcoss_dell_p3 fv3_conf/fv3_bsub.IN

elif [[ $MACHINE_ID = gaea.* ]]; then

  export NCEPLIBS=/lustre/f2/pdata/ncep_shared/NCEPLIBS7/lib
  source $PATHTR/NEMS/src/conf/module-setup.sh.inc

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3

  COMPILER=${NEMS_COMPILER:-intel}
  module use /lustre/f2/pdata/ncep/JieShun.Zhu/emc.nemspara/soft/modulefiles
  module load rocoto/1.3.1_new
  ROCOTORUN=/lustre/f2/pdata/ncep/JieShun.Zhu/emc.nemspara/soft/rocoto/rocoto/bin/rocotorun
  ROCOTOSTAT=/lustre/f2/pdata/ncep/JieShun.Zhu/emc.nemspara/soft/rocoto/rocoto/bin/rocotostat
  ROCOTOCOMPLETE=/lustre/f2/pdata/ncep/JieShun.Zhu/emc.nemspara/soft/rocoto/rocoto/bin/rocotocomplete

#  export PATH=/gpfs/hps/nco/ops/ecf/ecfdir/ecflow.v4.1.0.intel/bin:$PATH
  export PYTHONPATH=
  ECFLOW_START=
  # DH* 20190717 temporary
  #DISKNM=/lustre/f2/pdata/ncep_shared/emc.nemspara/RT
#  DISKNM=/lustre/f2/pdata/ncep/Weiyu.Yang/ncep_shared/emc.nemspara/Hera_RT
  DISKNM=/lustre/f2/pdata/ncep/JieShun.Zhu/emc.nemspara/Hera_RT
#  DISKNM=/lustre/f2/pdata/esrl/gsd/ufs/ufs-weather-model/RT
  # *DH 20190717
  QUEUE=urgent
#  DO NOT SET AN ACCOUNT EVERYONE IS NOT A MEMBER OF
#  USE AN ENVIRONMENT VARIABLE TO SET ACCOUNT
#  ACCNR=cfsrl
  ACCNR=cpcstrato
  PARTITION=c4
  STMP=/lustre/f2/scratch
  PTMP=/lustre/f2/scratch

  # default scheduler on Gaea
  SCHEDULER=slurm
  cp fv3_conf/fv3_slurm.IN_gaea fv3_conf/fv3_slurm.IN

elif [[ $MACHINE_ID = hera.* ]]; then

  export NCEPLIBS=/scratch1/NCEPDEV/global/gwv/l819/lib
  source $PATHTR/NEMS/src/conf/module-setup.sh.inc

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3

  # Re-instantiate COMPILER in case it gets deleted by module purge
  COMPILER=${NEMS_COMPILER:-intel}

  module load rocoto
  ROCOTORUN=$(which rocotorun)
  ROCOTOSTAT=$(which rocotostat)
  ROCOTOCOMPLETE=$(which rocotocomplete)
  export PATH=/scratch2/NCEPDEV/fv3-cam/Dusan.Jovic/ecflow/bin:$PATH
  export PYTHONPATH=/scratch2/NCEPDEV/fv3-cam/Dusan.Jovic/ecflow/lib/python2.7/site-packages
  ECFLOW_START=/scratch2/NCEPDEV/fv3-cam/Dusan.Jovic/ecflow/bin/ecflow_start.sh
  ECF_PORT=$(( $(id -u) + 1500 ))
  QUEUE=batch
#  ACCNR=fv3-cpu
  PARTITION=
  dprefix=/scratch1/NCEPDEV
  DISKNM=$dprefix/nems/emc.nemspara/RT
  STMP=$dprefix/stmp4
  PTMP=$dprefix/stmp2

  SCHEDULER=slurm
  cp fv3_conf/fv3_slurm.IN_hera fv3_conf/fv3_slurm.IN

elif [[ $MACHINE_ID = orion.* ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3
  module load gcc/8.3.0

  # Re-instantiate COMPILER in case it gets deleted by module purge
  COMPILER=${NEMS_COMPILER:-intel}

  module load rocoto/1.3.1
  ROCOTORUN=$(which rocotorun)
  ROCOTOSTAT=$(which rocotostat)
  ROCOTOCOMPLETE=$(which rocotocomplete)
  export PATH=/work/noaa/fv3-cam/djovic/ecflow/bin:$PATH
  export PYTHONPATH=/work/noaa/fv3-cam/djovic/ecflow/lib/python2.7/site-packages
  ECFLOW_START=/work/noaa/fv3-cam/djovic/ecflow/bin/ecflow_start.sh
  ECF_PORT=$(( $(id -u) + 1500 ))
  QUEUE=batch
#  ACCNR= # detected in detect_machine.sh
  PARTITION=orion
  dprefix=/work/noaa/stmp/${USER}
  DISKNM=/work/noaa/nems/emc.nemspara/RT
  STMP=$dprefix/stmp
  PTMP=$dprefix/stmp

  SCHEDULER=slurm
  cp fv3_conf/fv3_slurm.IN_orion fv3_conf/fv3_slurm.IN

elif [[ $MACHINE_ID = jet.* ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc

  module use $PATHTR/modulefiles/${MACHINE_ID}
  module load fv3

  # Re-instantiate COMPILER in case it gets deleted by module purge
  COMPILER=${NEMS_COMPILER:-intel}

  module load rocoto/1.3.1
  ROCOTORUN=$(which rocotorun)
  ROCOTOSTAT=$(which rocotostat)
  ROCOTOCOMPLETE=$(which rocotocomplete)

  export PATH=/mnt/lfs3/projects/hfv3gfs/Dusan.Jovic/ecflow/bin:$PATH
  export PYTHONPATH=/mnt/lfs3/projects/hfv3gfs/Dusan.Jovic/ecflow/lib/python2.7/site-packages
  ECFLOW_START=/mnt/lfs3/projects/hfv3gfs/Dusan.Jovic/ecflow/bin/ecflow_start.sh
  ECF_PORT=$(( $(id -u) + 1500 ))
  QUEUE=debug
  ACCNR=hfv3gfs
  PARTITION=xjet
  DISKNM=/lfs3/projects/hfv3gfs/GMTB/RT
  dprefix=/lfs3/projects/hfv3gfs/$USER
  STMP=$dprefix/RT_BASELINE
  PTMP=$dprefix/RT_RUNDIRS

  # default scheduler on Jet
  SCHEDULER=slurm
  cp fv3_conf/fv3_slurm.IN_jet fv3_conf/fv3_slurm.IN

elif [[ $MACHINE_ID = cheyenne.* ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc
  # Re-instantiate COMPILER in case it gets deleted by module purge
  COMPILER=${NEMS_COMPILER:-intel}

  export PYTHONPATH=
  ECFLOW_START=
  QUEUE=premium
  PARTITION=
  dprefix=/glade/scratch
  DISKNM=/glade/p/ral/jntp/GMTB/NEMSfv3gfs/RT
  STMP=$dprefix
  PTMP=$dprefix
  SCHEDULER=pbs
  cp fv3_conf/fv3_qsub.IN_cheyenne fv3_conf/fv3_qsub.IN

elif [[ $MACHINE_ID = stampede.* ]]; then

  source $PATHTR/NEMS/src/conf/module-setup.sh.inc
  # Re-instantiate COMPILER in case it gets deleted by module purge
  COMPILER=${NEMS_COMPILER:-intel}

  export PYTHONPATH=
  ECFLOW_START=
  QUEUE=skx-dev
  PARTITION=
  dprefix=$WORK/NEMSfv3gfs/run
  DISKNM=$WORK/NEMSfv3gfs/RT
  STMP=$dprefix/stmp4
  PTMP=$dprefix/stmp3
  SCHEDULER=sbatch
  MPIEXEC=ibrun
  MPIEXECOPTS=
  cp fv3_conf/fv3_qsub.IN_stampede fv3_conf/fv3_qsub.IN

else
  die "Unknown machine ID, please edit detect_machine.sh file"
fi

mkdir -p ${STMP}/${USER}

# Different own baseline directories for different compilers
NEW_BASELINE=${STMP}/${USER}/S2S_RT/REGRESSION_TEST_c20b
#if [[ $MACHINE_ID = cheyenne.* ]] || [[ $MACHINE_ID = jet.* ]] || [[ $MACHINE_ID = gaea.* ]]; then
if [[ $MACHINE_ID = hera.* ]] || [[ $MACHINE_ID = orion.* ]] || [[ $MACHINE_ID = cheyenne.* ]]; then
    NEW_BASELINE=${NEW_BASELINE}_${COMPILER^^}
fi

# Overwrite default RUNDIR_ROOT if environment variable RUNDIR_ROOT is set
#RUNDIR_ROOT=${RUNDIR_ROOT:-${PTMP}/${USER}/S2S_RT}/rt_$$
#RUNDIR_ROOT=${RUNDIR_ROOT:-${PTMP}/${USER}/S2S_RT}/rt_20126
#RUNDIR_ROOT=${RUNDIR_ROOT:-${PTMP}/${USER}/S2S_RT}/fcst_201408
#mkdir -p ${RUNDIR_ROOT}

CREATE_BASELINE=false
ROCOTO=false
ECFLOW=false
KEEP_RUNDIR=false
SINGLE_NAME=''
TEST_3mo=false

TESTS_FILE='rt.conf'
# Switch to special regression test config on wcoss_cray:
# don't run the IPD and CCPP tests in REPRO mode.
if [[ $MACHINE_ID = wcoss_cray ]]; then
  TESTS_FILE='rt_wcoss_cray.conf'
fi

SET_ID='standard'
while getopts ":cfsl:mn:kreh" opt; do
  case $opt in
    c)
      CREATE_BASELINE=true
      SET_ID=' '
      ;;
    f)
      SET_ID=' '
      ;;
    s)
      SET_ID='standard'
      ;;
    l)
      TESTS_FILE=$OPTARG
      SET_ID=' '
      ;;
    m)
      # redefine RTPWD to point to newly created baseline outputs
      RTPWD=${NEW_BASELINE}
      ;;
    n)
      SINGLE_NAME=$OPTARG
      TESTS_FILE='rt.conf.single'
      SET_ID=' '
      rm -f $TESTS_FILE
      ;;
    k)
      KEEP_RUNDIR=true
      ;;
    r)
      ROCOTO=true
      ECFLOW=false
      ;;
    e)
      ECFLOW=true
      ROCOTO=false
      ;;
    h)
      usage
      ;;
    \?)
      usage
      die "Invalid option: -$OPTARG"
      ;;
    :)
      usage
      die "Option -$OPTARG requires an argument."
      ;;
  esac
done

if [[ $SINGLE_NAME != '' ]]; then
  rt_single
fi

if [[ $TESTS_FILE =~ '3mo' ]]; then
  TEST_3mo=true
fi

if [[ $MACHINE_ID = cheyenne.* ]]; then
  RTPWD=${RTPWD:-$DISKNM/develop-20200210/${COMPILER^^}}
else
  RTPWD=${RTPWD:-$DISKNM/FV3-MOM6-CICE5/develop-20200907-zbot}
fi

shift $((OPTIND-1))
[[ $# -gt 1 ]] && usage

if [[ $CREATE_BASELINE == true ]]; then
  #
  # prepare new regression test directory
  #
  rm -rf "${NEW_BASELINE}"
  mkdir -p "${NEW_BASELINE}"
  echo "copy baseline inputs form: ${RTPWD}"
  echo "                     to:   ${NEW_BASELINE}"

  rsync -a "${RTPWD}"/FV3_* "${NEW_BASELINE}"/
  rsync -a "${RTPWD}"/MOM6_* "${NEW_BASELINE}"/
  rsync -a "${RTPWD}"/CICE_* "${NEW_BASELINE}"/
  rsync -a "${RTPWD}"/CPL_* "${NEW_BASELINE}"/
  rsync -a "${RTPWD}"/WW3_* "${NEW_BASELINE}"/
  rsync -a "${RTPWD}"/BM_* "${NEW_BASELINE}"/

  # FIXME: move these namelist files to parm directory
  #rsync -a "${RTPWD}"/fv3_regional_control/input.nml "${NEW_BASELINE}"/fv3_regional_control/
  #rsync -a "${RTPWD}"/fv3_regional_quilt/input.nml   "${NEW_BASELINE}"/fv3_regional_quilt/
  #rsync -a "${RTPWD}"/fv3_regional_c768/input.nml    "${NEW_BASELINE}"/fv3_regional_c768/
  #rsync -a "${RTPWD}"/fv3_regional_restart/input.nml "${NEW_BASELINE}"/fv3_regional_restart/

  #rsync -a "${RTPWD}"/fv3_regional_control/model_configure "${NEW_BASELINE}"/fv3_regional_control/
  #rsync -a "${RTPWD}"/fv3_regional_quilt/model_configure   "${NEW_BASELINE}"/fv3_regional_quilt/
  #rsync -a "${RTPWD}"/fv3_regional_c768/model_configure    "${NEW_BASELINE}"/fv3_regional_c768/
  #rsync -a "${RTPWD}"/fv3_regional_restart/model_configure "${NEW_BASELINE}"/fv3_regional_restart/

  #rsync -a "${RTPWD}"/fv3_regional_control/INPUT     "${NEW_BASELINE}"/fv3_regional_control/
  #rsync -a "${RTPWD}"/fv3_regional_quilt/INPUT       "${NEW_BASELINE}"/fv3_regional_quilt/
  #rsync -a "${RTPWD}"/fv3_regional_c768/INPUT        "${NEW_BASELINE}"/fv3_regional_c768/
  #rsync -a "${RTPWD}"/fv3_regional_restart/INPUT     "${NEW_BASELINE}"/fv3_regional_restart/
  #rsync -a "${RTPWD}"/fv3_stretched/INPUT            "${NEW_BASELINE}"/fv3_stretched/
  #rsync -a "${RTPWD}"/fv3_stretched_nest/INPUT       "${NEW_BASELINE}"/fv3_stretched_nest/
  #rsync -a "${RTPWD}"/fv3_stretched_nest_quilt/INPUT "${NEW_BASELINE}"/fv3_stretched_nest_quilt/

  RTPWD=${NEW_BASELINE}
fi

COMPILE_LOG=${PATHRT}/Compile_$MACHINE_ID.log
REGRESSIONTEST_LOG=${PATHRT}/RegressionTests_$MACHINE_ID.log

date > ${REGRESSIONTEST_LOG}
echo "Start Regression test" >> ${REGRESSIONTEST_LOG}
echo                         >> ${REGRESSIONTEST_LOG}

source default_vars.sh

TEST_NR=0
COMPILE_NR=0
COMPILE_PREV_WW3_NR=''
rm -f fail_test

LOG_DIR=${PATHRT}/log_$MACHINE_ID
#rm -rf ${LOG_DIR}
mkdir -p ${LOG_DIR}

if [[ $ROCOTO == true ]]; then

  ROCOTO_XML=${PATHRT}/rocoto_workflow.xml
  ROCOTO_DB=${PATHRT}/rocoto_workflow.db

  rm -f $ROCOTO_XML $ROCOTO_DB *_lock.db

  if [[ $MACHINE_ID = wcoss ]]; then
    QUEUE=dev
    COMPILE_QUEUE=dev
    ROCOTO_SCHEDULER=lsf
  elif [[ $MACHINE_ID = wcoss_cray ]]; then
    QUEUE=dev
    COMPILE_QUEUE=dev
    ROCOTO_SCHEDULER=lsfcray
  elif [[ $MACHINE_ID = wcoss_dell_p3 ]]; then
    QUEUE=dev
    COMPILE_QUEUE=dev_transfer
    ROCOTO_SCHEDULER=lsf
  elif [[ $MACHINE_ID = hera.* ]]; then
    QUEUE=batch
    COMPILE_QUEUE=batch
    ROCOTO_SCHEDULER=slurm
  elif [[ $MACHINE_ID = orion.* ]]; then
    QUEUE=batch
    COMPILE_QUEUE=batch
    ROCOTO_SCHEDULER=slurm
  elif [[ $MACHINE_ID = jet.* ]]; then
    QUEUE=batch
    COMPILE_QUEUE=batch
    ROCOTO_SCHEDULER=slurm
  else
    die "Rocoto is not supported on this machine $MACHINE_ID"
  fi

  cat << EOF > $ROCOTO_XML
<?xml version="1.0"?>
<!DOCTYPE workflow
[
  <!ENTITY PATHRT       "${PATHRT}">
  <!ENTITY LOG          "${LOG_DIR}">
  <!ENTITY PATHTR       "${PATHTR}">
  <!ENTITY RTPWD        "${RTPWD}">
  <!ENTITY RUNDIR_ROOT  "${RUNDIR_ROOT}">
  <!ENTITY NEW_BASELINE "${NEW_BASELINE}">
]>
<workflow realtime="F" scheduler="${ROCOTO_SCHEDULER}" taskthrottle="20">
  <cycledef>197001010000 197001010000 01:00:00</cycledef>
  <log>&LOG;/workflow.log</log>
EOF

fi

if [[ $ECFLOW == true ]]; then

  ECFLOW_RUN=${PATHRT}/ecflow_run
  ECFLOW_SUITE=regtest_$$
  rm -rf ${ECFLOW_RUN}
  mkdir -p ${ECFLOW_RUN}/${ECFLOW_SUITE}
  cp head.h tail.h ${ECFLOW_RUN}
  > ${ECFLOW_RUN}/${ECFLOW_SUITE}.def
  cat << EOF >> ${ECFLOW_RUN}/${ECFLOW_SUITE}.def
suite ${ECFLOW_SUITE}
    edit ECF_HOME '${ECFLOW_RUN}'
    edit ECF_INCLUDE '${ECFLOW_RUN}'
    edit ECF_KILL_CMD kill -15 %ECF_RID% > %ECF_JOB%.kill 2>&1
    edit ECF_TRIES 1
    label rundir_root '${RUNDIR_ROOT}'
    limit max_builds 1
    limit max_jobs 30
EOF

  if [[ $MACHINE_ID = wcoss ]]; then
    QUEUE=dev
  elif [[ $MACHINE_ID = wcoss_cray ]]; then
    QUEUE=dev
  elif [[ $MACHINE_ID = wcoss_dell_p3 ]]; then
    QUEUE=dev
  elif [[ $MACHINE_ID = hera.* ]]; then
    QUEUE=batch
  elif [[ $MACHINE_ID = orion.* ]]; then
    QUEUE=batch
  elif [[ $MACHINE_ID = jet.* ]]; then
    QUEUE=batch
  else
    die "ecFlow is not supported on this machine $MACHINE_ID"
  fi

fi

##
## read rt.conf and then either execute the test script directly or create
## workflow description file
##

new_compile=false
in_metatask=false

[[ -f $TESTS_FILE ]] || die "$TESTS_FILE does not exist"

while read -r line; do

  line="${line#"${line%%[![:space:]]*}"}"
  [[ ${#line} == 0 ]] && continue
  [[ $line == \#* ]] && continue

  if [[ $line == COMPILE* ]] ; then

      APP=''
      NEMS_VER=$(echo $line | cut -d'|' -f2 | sed -e 's/^ *//' -e 's/ *$//')
      SET=$(     echo $line | cut -d'|' -f3)
      MACHINES=$(echo $line | cut -d'|' -f4 | sed -e 's/^ *//' -e 's/ *$//')
      CB=$(      echo $line | cut -d'|' -f5)

      [[ $SET_ID != ' ' && $SET != *${SET_ID}* ]] && continue
      [[ $MACHINES != ' ' && $MACHINES != "${MACHINE_ID}" ]] && continue
      [[ $CREATE_BASELINE == true && $CB != *fv3* ]] && continue

      COMPILE_NR_DEP=${COMPILE_NR}
      (( COMPILE_NR += 1 ))

      if [[ $ROCOTO == true ]]; then
        rocoto_create_compile_task
      elif [[ $ECFLOW == true ]]; then
        ecflow_create_compile_task
      else
        ./compile.sh $PATHTR/FV3 $MACHINE_ID "${NEMS_VER}" $COMPILE_NR > ${LOG_DIR}/compile_${COMPILE_NR}.log 2>&1
        echo " bash Compile is done"
      fi

      # Set RT_SUFFIX (regression test run directories and log files) and BL_SUFFIX
      # (regression test baseline directories) for REPRO (IPD, CCPP) or PROD (CCPP) runs
      #if [[ ${NEMS_VER^^} =~ "REPRO=Y" ]]; then
      #  RT_SUFFIX="_repro"
      #  BL_SUFFIX="_repro"
      #elif [[ ${NEMS_VER^^} =~ "CCPP=Y" ]]; then
      #  RT_SUFFIX="_prod"
      #  BL_SUFFIX="_ccpp"
      #fi

      if [[ ${NEMS_VER^^} =~ "WW3=Y" ]]; then
         COMPILE_PREV_WW3_NR=${COMPILE_NR}
      fi

    continue

  elif [[ $line == APPBUILD* ]] ; then

      APP=$(     echo $line | cut -d'|' -f2 | sed -e 's/^ *//' -e 's/ *$//')
      SET=$(     echo $line | cut -d'|' -f3)
      MACHINES=$(echo $line | cut -d'|' -f4 | sed -e 's/^ *//' -e 's/ *$//')
      CB=$(      echo $line | cut -d'|' -f5)

      [[ $SET_ID != ' ' && $SET != *${SET_ID}* ]] && continue
      [[ $MACHINES != ' ' && $MACHINES != "${MACHINE_ID}" ]] && continue
      [[ $CREATE_BASELINE == true && $CB != *fv3* ]] && continue
      [[ ${ROCOTO} == true || ${ECFLOW} == true ]] && continue

      (( COMPILE_NR += 1 ))

      if [[ $ROCOTO == true ]]; then
        rocoto_create_compile_task
      elif [[ $ECFLOW == true ]]; then
        ecflow_create_compile_task
      else
          echo test  > "${LOG_DIR}/compile_${COMPILE_NR}.log" 2>&1
          test -s ./appbuild.sh
          test -x ./appbuild.sh
        MACHINE_ID=${MACHINE_ID} ./appbuild.sh "$PATHTR/FV3" "$APP" "$COMPILE_NR" > ${LOG_DIR}/compile_${COMPILE_NR}.log 2>&1
        echo " bash NEMSAppBuilder is done"
      fi

      # Set RT_SUFFIX (regression test run directories and log files) and BL_SUFFIX
      # (regression test baseline directories) for REPRO (IPD, CCPP) or PROD (CCPP) runs
      if [[ ${NEMS_VER^^} =~ "REPRO=Y" ]]; then
        RT_SUFFIX="_repro"
        BL_SUFFIX="_repro"
      elif [[ ${NEMS_VER^^} =~ "CCPP=Y" ]]; then
        RT_SUFFIX="_prod"
        BL_SUFFIX="_ccpp"
      fi

      unset APP
    continue

  elif [[ $line == RUN* ]] ; then

    TEST_NAME=$(echo $line | cut -d'|' -f2 | sed -e 's/^ *//' -e 's/ *$//')
    SET=$(      echo $line | cut -d'|' -f3)
    MACHINES=$( echo $line | cut -d'|' -f4)
    CB=$(       echo $line | cut -d'|' -f5)
    DEP_RUN=$(  echo $line | cut -d'|' -f6 | sed -e 's/^ *//' -e 's/ *$//')
    DATE_3mo=$( echo $line | cut -d'|' -f7 | sed -e 's/^ *//' -e 's/ *$//')
#    DATE_3mo=$(  echo $line | cut -d'|' -f6 | sed -e 's/^ *//' -e 's/ *$//')

    fcstyr=$(echo ${DATE_3mo} | cut -c 1-4)
    RUNDIR_ROOT=${RUNDIR_ROOT:-${PTMP}/${USER}/UFS_zbot/fcst_${fcstyr}b}
    mkdir -p ${RUNDIR_ROOT}

    [[ -e "tests/$TEST_NAME" ]] || die "run test file tests/$TEST_NAME does not exist"
    [[ $SET_ID != ' ' && $SET != *${SET_ID}* ]] && continue
    [[ $MACHINES != ' ' && $MACHINES != *${MACHINE_ID}* ]] && continue
    [[ $CREATE_BASELINE == true && $CB != *fv3* ]] && continue

    # 45 day tests
    [[ $TEST_3mo == true ]] && rt_3mo

    # skip all *_appbuild runs if rocoto or ecFlow is used. FIXME
    if [[ ${ROCOTO} == true && ${ECFLOW} == true ]]; then
      if [[ ${TEST_NAME} == *_appbuild ]]; then
      continue
      fi
    fi

    # Avoid uninitialized RT_SUFFIX/BL_SUFFIX (see definition above)
    RT_SUFFIX=${RT_SUFFIX:-""}
    BL_SUFFIX=${BL_SUFFIX:-""}

    if [[ $MACHINE_ID = wcoss_cray ]]; then
    if [[ $RT_SUFFIX != "" || $BL_SUFFIX != "" ]]; then
      # skip all REPRO and/or CCPP runs on wcoss_cray. FIXME
      continue
    fi
    fi

    if [[ $ROCOTO == true && $new_compile == true ]]; then
      new_compile=false
      in_metatask=true
      cat << EOF >> $ROCOTO_XML
  <metatask name="compile_${COMPILE_NR}_tasks"><var name="zero">0</var>
EOF
    fi

    TEST_NR=$( printf '%03d' $(( 10#$TEST_NR + 1 )) )

    (
      source ${PATHRT}/tests/$TEST_NAME

      cat << EOF > ${RUNDIR_ROOT}/run_test_${TEST_NR}.env
      export MACHINE_ID=${MACHINE_ID}
      export RTPWD=${RTPWD}
      export PATHRT=${PATHRT}
      export PATHTR=${PATHTR}
      export NEW_BASELINE=${NEW_BASELINE}
      export CREATE_BASELINE=${CREATE_BASELINE}
      export RT_SUFFIX=${RT_SUFFIX}
      export BL_SUFFIX=${BL_SUFFIX}
      export SCHEDULER=${SCHEDULER}
      export ACCNR=${ACCNR}
      export QUEUE=${QUEUE}
      export PARTITION=${PARTITION}
      export ROCOTO=${ROCOTO}
      export LOG_DIR=${LOG_DIR}
      export DEP_RUN=${DEP_RUN}
EOF

      if [[ $ROCOTO == true ]]; then
        rocoto_create_run_task
      elif [[ $ECFLOW == true ]]; then
        ecflow_create_run_task
      else
        ./run_test.sh ${PATHRT} ${RUNDIR_ROOT} ${TEST_NAME} ${TEST_NR} ${COMPILE_NR} > ${LOG_DIR}/run_${TEST_NAME}${RT_SUFFIX}.log 2>&1
      fi
    )

    continue
  else
    die "Unknown command $line"
  fi
done < $TESTS_FILE

##
## run regression test workflow (currently Rocoto or ecFlow are supported)
##

if [[ $ROCOTO == true ]]; then
  if [[ $in_metatask == true ]]; then
    echo "  </metatask>" >> $ROCOTO_XML
  fi
  echo "</workflow>" >> $ROCOTO_XML
  # run rocoto workflow until done
  rocoto_run
fi

if [[ $ECFLOW == true ]]; then
  echo "endsuite" >> ${ECFLOW_RUN}/${ECFLOW_SUITE}.def
  # run ecflow workflow until done
  ecflow_run
fi

##
## regression test is either failed or successful
##
set +e
cat ${LOG_DIR}/compile_*.log                   >  ${COMPILE_LOG}
cat ${LOG_DIR}/rt_*.log                        >> ${REGRESSIONTEST_LOG}
if [[ -e fail_test ]]; then
  echo "FAILED TESTS: "
  echo "FAILED TESTS: "                        >> ${REGRESSIONTEST_LOG}
  while read -r failed_test_name
  do
    echo "Test ${failed_test_name} failed "
    echo "Test ${failed_test_name} failed "    >> ${REGRESSIONTEST_LOG}
  done < fail_test
   echo ; echo REGRESSION TEST FAILED
  (echo ; echo REGRESSION TEST FAILED)         >> ${REGRESSIONTEST_LOG}
else
   echo ; echo REGRESSION TEST WAS SUCCESSFUL
  (echo ; echo REGRESSION TEST WAS SUCCESSFUL) >> ${REGRESSIONTEST_LOG}

#  rm -f fcst_*.x fcst_*.exe modules.fcst_*
#  [[ ${KEEP_RUNDIR} == false ]] && rm -rf ${RUNDIR_ROOT}
#  [[ ${ROCOTO} == true ]] && rm -f ${ROCOTO_XML} ${ROCOTO_DB} *_lock.db
#  [[ ${TEST_3mo} == true ]] && rm -f tests/cpld_*cmeps*_20*
fi

date >> ${REGRESSIONTEST_LOG}

elapsed_time=$( printf '%02dh:%02dm:%02ds\n' $(($SECONDS%86400/3600)) $(($SECONDS%3600/60)) $(($SECONDS%60)) )
echo "Elapsed time: ${elapsed_time}. Have a nice day!" >> ${REGRESSIONTEST_LOG}
echo "Elapsed time: ${elapsed_time}. Have a nice day!"
