set(CMAKE_C_COMPILER "/opt/cray/pe/craype/2.7.15/bin/cc")
set(CMAKE_C_COMPILER_ARG1 "")
set(CMAKE_C_COMPILER_ID "Intel")
set(CMAKE_C_COMPILER_VERSION "20.2.7.20221019")
set(CMAKE_C_COMPILER_VERSION_INTERNAL "")
set(CMAKE_C_COMPILER_WRAPPER "CrayPrgEnv")
set(CMAKE_C_STANDARD_COMPUTED_DEFAULT "11")
set(CMAKE_C_COMPILE_FEATURES "c_std_90;c_function_prototypes;c_std_99;c_restrict;c_variadic_macros;c_std_11;c_static_assert")
set(CMAKE_C90_COMPILE_FEATURES "c_std_90;c_function_prototypes")
set(CMAKE_C99_COMPILE_FEATURES "c_std_99;c_restrict;c_variadic_macros")
set(CMAKE_C11_COMPILE_FEATURES "c_std_11;c_static_assert")

set(CMAKE_C_PLATFORM_ID "Linux")
set(CMAKE_C_SIMULATE_ID "GNU")
set(CMAKE_C_COMPILER_FRONTEND_VARIANT "")
set(CMAKE_C_SIMULATE_VERSION "7.5.0")



set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_C_COMPILER_AR "")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_C_COMPILER_RANLIB "")
set(CMAKE_LINKER "/usr/bin/ld")
set(CMAKE_MT "")
set(CMAKE_COMPILER_IS_GNUCC )
set(CMAKE_C_COMPILER_LOADED 1)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_C_ABI_COMPILED TRUE)
set(CMAKE_COMPILER_IS_MINGW )
set(CMAKE_COMPILER_IS_CYGWIN )
if(CMAKE_COMPILER_IS_CYGWIN)
  set(CYGWIN 1)
  set(UNIX 1)
endif()

set(CMAKE_C_COMPILER_ENV_VAR "CC")

if(CMAKE_COMPILER_IS_MINGW)
  set(MINGW 1)
endif()
set(CMAKE_C_COMPILER_ID_RUN 1)
set(CMAKE_C_SOURCE_FILE_EXTENSIONS c;m)
set(CMAKE_C_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_C_LINKER_PREFERENCE 10)

# Save compiler ABI information.
set(CMAKE_C_SIZEOF_DATA_PTR "8")
set(CMAKE_C_COMPILER_ABI "ELF")
set(CMAKE_C_LIBRARY_ARCHITECTURE "")

if(CMAKE_C_SIZEOF_DATA_PTR)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_C_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_C_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_C_COMPILER_ABI}")
endif()

if(CMAKE_C_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()

set(CMAKE_C_CL_SHOWINCLUDES_PREFIX "")
if(CMAKE_C_CL_SHOWINCLUDES_PREFIX)
  set(CMAKE_CL_SHOWINCLUDES_PREFIX "${CMAKE_C_CL_SHOWINCLUDES_PREFIX}")
endif()





set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "/opt/cray/pe/mpt/7.7.20/gni/mpich-intel/16.0/include;/opt/cray/pe/libsci/22.05.1/INTEL/16.0/x86_64/include;/opt/cray/rca/2.2.22-7.0.4.1_2.35__ged51428.ari/include;/opt/cray/gni-headers/default/include;/opt/cray/ugni/default/include;/opt/cray/udreg/default/include;/opt/cray/alps/6.6.67-7.0.4.1_2.36__gb91cd181.ari/include;/opt/cray/pe/pmi/5.0.17/include;/opt/cray/xpmem/default/include;/opt/cray/wlm_detect/1.3.3-7.0.4.1_2.18__g7109084.ari/include;/opt/cray/krca/2.2.8-7.0.4.1_2.26__g59af36e.ari/include;/opt/cray-hss-devel/9.0.0/include;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/python-2.7.12-qpantrl4lgx5jj32c6r54ztixgljem5c/include;/opt/intel/oneapi/mkl/2022.2.1/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/globus-toolkit-6.0.17-klqyvmmhxqsf77ita7vvlw3wgyire7df/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/ncl-6.6.2-lekqd2ieivfhsd3cr2spmm5hibfwatg7/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/nco-4.7.9-wrjhlc76ydejqa2atomybt6h2qh5xi3p/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/wgrib2-2.0.8-wmuvhcduakhxv2v23e3gqquhgtwzhyb4/include;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include/intel64;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include/icc;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include;/usr/local/include;/usr/lib64/gcc/x86_64-suse-linux/7/include;/usr/lib64/gcc/x86_64-suse-linux/7/include-fixed;/usr/include")
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "darshan;fmpich;mpichcxx;darshan;z;sci_intel_mpi;sci_intel;imf;m;dl;mpich_intel;rt;ugni;pthread;pmi;imf;m;dl;pmi;pthread;alpslli;pthread;wlm_detect;alpsutil;pthread;rca;xpmem;ugni;pthread;udreg;sci_intel;imf;m;pthread;dl;hugetlbfs;imf;m;ifcoremt;ifport;pthread;imf;svml;irng;m;ipgo;decimal;gcc;irc;svml;c;gcc;irc_s;dl;c")
set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/opt/cray/dmapp/default/lib64;/opt/cray/pe/mpt/7.7.20/gni/mpich-intel/16.0/lib;/opt/cray/pe/libsci/22.05.1/INTEL/16.0/x86_64/lib;/opt/cray/rca/2.2.22-7.0.4.1_2.35__ged51428.ari/lib64;/opt/cray/ugni/default/lib64;/opt/cray/udreg/default/lib64;/opt/cray/alps/6.6.67-7.0.4.1_2.36__gb91cd181.ari/lib64;/opt/cray/pe/pmi/5.0.17/lib64;/sw/gaea-cle7/darshan/3.2.1-1/runtime/lib;/opt/cray/xpmem/default/lib64;/opt/cray/wlm_detect/1.3.3-7.0.4.1_2.18__g7109084.ari/lib64;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/git-2.9.3-qvbxg2vs55dnnegneixfwnlgjelcpyiw/lib;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/python-2.7.12-qpantrl4lgx5jj32c6r54ztixgljem5c/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/globus-toolkit-6.0.17-klqyvmmhxqsf77ita7vvlw3wgyire7df/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/ncl-6.6.2-lekqd2ieivfhsd3cr2spmm5hibfwatg7/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/nco-4.7.9-wrjhlc76ydejqa2atomybt6h2qh5xi3p/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/wgrib2-2.0.8-wmuvhcduakhxv2v23e3gqquhgtwzhyb4/lib;/opt/intel/oneapi/mkl/2022.2.1/lib/intel64;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/lib/intel64_lin;/opt/intel/oneapi/compiler/2022.2.1/linux/lib;/usr/lib64/gcc/x86_64-suse-linux/7;/usr/lib64;/lib64;/usr/x86_64-suse-linux/lib;/lib;/usr/lib")
set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
