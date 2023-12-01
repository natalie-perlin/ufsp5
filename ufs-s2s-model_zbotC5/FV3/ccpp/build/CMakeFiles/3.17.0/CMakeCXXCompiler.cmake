set(CMAKE_CXX_COMPILER "/opt/cray/pe/craype/2.7.15/bin/CC")
set(CMAKE_CXX_COMPILER_ARG1 "")
set(CMAKE_CXX_COMPILER_ID "Intel")
set(CMAKE_CXX_COMPILER_VERSION "20.2.7.20221019")
set(CMAKE_CXX_COMPILER_VERSION_INTERNAL "")
set(CMAKE_CXX_COMPILER_WRAPPER "CrayPrgEnv")
set(CMAKE_CXX_STANDARD_COMPUTED_DEFAULT "14")
set(CMAKE_CXX_COMPILE_FEATURES "cxx_std_98;cxx_template_template_parameters;cxx_std_11;cxx_alias_templates;cxx_alignas;cxx_alignof;cxx_attributes;cxx_auto_type;cxx_constexpr;cxx_decltype;cxx_decltype_incomplete_return_types;cxx_default_function_template_args;cxx_defaulted_functions;cxx_defaulted_move_initializers;cxx_delegating_constructors;cxx_deleted_functions;cxx_enum_forward_declarations;cxx_explicit_conversions;cxx_extended_friend_declarations;cxx_extern_templates;cxx_final;cxx_func_identifier;cxx_generalized_initializers;cxx_inheriting_constructors;cxx_inline_namespaces;cxx_lambdas;cxx_local_type_template_args;cxx_long_long_type;cxx_noexcept;cxx_nonstatic_member_init;cxx_nullptr;cxx_override;cxx_range_for;cxx_raw_string_literals;cxx_reference_qualified_functions;cxx_right_angle_brackets;cxx_rvalue_references;cxx_sizeof_member;cxx_static_assert;cxx_strong_enums;cxx_thread_local;cxx_trailing_return_types;cxx_unicode_literals;cxx_uniform_initialization;cxx_unrestricted_unions;cxx_user_literals;cxx_variadic_macros;cxx_variadic_templates;cxx_std_14;cxx_aggregate_default_initializers;cxx_attribute_deprecated;cxx_binary_literals;cxx_contextual_conversions;cxx_decltype_auto;cxx_digit_separators;cxx_generic_lambdas;cxx_lambda_init_captures;cxx_relaxed_constexpr;cxx_return_type_deduction;cxx_variable_templates;cxx_std_17")
set(CMAKE_CXX98_COMPILE_FEATURES "cxx_std_98;cxx_template_template_parameters")
set(CMAKE_CXX11_COMPILE_FEATURES "cxx_std_11;cxx_alias_templates;cxx_alignas;cxx_alignof;cxx_attributes;cxx_auto_type;cxx_constexpr;cxx_decltype;cxx_decltype_incomplete_return_types;cxx_default_function_template_args;cxx_defaulted_functions;cxx_defaulted_move_initializers;cxx_delegating_constructors;cxx_deleted_functions;cxx_enum_forward_declarations;cxx_explicit_conversions;cxx_extended_friend_declarations;cxx_extern_templates;cxx_final;cxx_func_identifier;cxx_generalized_initializers;cxx_inheriting_constructors;cxx_inline_namespaces;cxx_lambdas;cxx_local_type_template_args;cxx_long_long_type;cxx_noexcept;cxx_nonstatic_member_init;cxx_nullptr;cxx_override;cxx_range_for;cxx_raw_string_literals;cxx_reference_qualified_functions;cxx_right_angle_brackets;cxx_rvalue_references;cxx_sizeof_member;cxx_static_assert;cxx_strong_enums;cxx_thread_local;cxx_trailing_return_types;cxx_unicode_literals;cxx_uniform_initialization;cxx_unrestricted_unions;cxx_user_literals;cxx_variadic_macros;cxx_variadic_templates")
set(CMAKE_CXX14_COMPILE_FEATURES "cxx_std_14;cxx_aggregate_default_initializers;cxx_attribute_deprecated;cxx_binary_literals;cxx_contextual_conversions;cxx_decltype_auto;cxx_digit_separators;cxx_generic_lambdas;cxx_lambda_init_captures;cxx_relaxed_constexpr;cxx_return_type_deduction;cxx_variable_templates")
set(CMAKE_CXX17_COMPILE_FEATURES "cxx_std_17")
set(CMAKE_CXX20_COMPILE_FEATURES "")

set(CMAKE_CXX_PLATFORM_ID "Linux")
set(CMAKE_CXX_SIMULATE_ID "GNU")
set(CMAKE_CXX_COMPILER_FRONTEND_VARIANT "")
set(CMAKE_CXX_SIMULATE_VERSION "7.5.0")



set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_CXX_COMPILER_AR "")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_CXX_COMPILER_RANLIB "")
set(CMAKE_LINKER "/usr/bin/ld")
set(CMAKE_MT "")
set(CMAKE_COMPILER_IS_GNUCXX )
set(CMAKE_CXX_COMPILER_LOADED 1)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_CXX_ABI_COMPILED TRUE)
set(CMAKE_COMPILER_IS_MINGW )
set(CMAKE_COMPILER_IS_CYGWIN )
if(CMAKE_COMPILER_IS_CYGWIN)
  set(CYGWIN 1)
  set(UNIX 1)
endif()

set(CMAKE_CXX_COMPILER_ENV_VAR "CXX")

if(CMAKE_COMPILER_IS_MINGW)
  set(MINGW 1)
endif()
set(CMAKE_CXX_COMPILER_ID_RUN 1)
set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS C;M;c++;cc;cpp;cxx;m;mm;CPP)
set(CMAKE_CXX_IGNORE_EXTENSIONS inl;h;hpp;HPP;H;o;O;obj;OBJ;def;DEF;rc;RC)

foreach (lang C OBJC OBJCXX)
  if (CMAKE_${lang}_COMPILER_ID_RUN)
    foreach(extension IN LISTS CMAKE_${lang}_SOURCE_FILE_EXTENSIONS)
      list(REMOVE_ITEM CMAKE_CXX_SOURCE_FILE_EXTENSIONS ${extension})
    endforeach()
  endif()
endforeach()

set(CMAKE_CXX_LINKER_PREFERENCE 30)
set(CMAKE_CXX_LINKER_PREFERENCE_PROPAGATES 1)

# Save compiler ABI information.
set(CMAKE_CXX_SIZEOF_DATA_PTR "8")
set(CMAKE_CXX_COMPILER_ABI "ELF")
set(CMAKE_CXX_LIBRARY_ARCHITECTURE "")

if(CMAKE_CXX_SIZEOF_DATA_PTR)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_CXX_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_CXX_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_CXX_COMPILER_ABI}")
endif()

if(CMAKE_CXX_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()

set(CMAKE_CXX_CL_SHOWINCLUDES_PREFIX "")
if(CMAKE_CXX_CL_SHOWINCLUDES_PREFIX)
  set(CMAKE_CL_SHOWINCLUDES_PREFIX "${CMAKE_CXX_CL_SHOWINCLUDES_PREFIX}")
endif()





set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/opt/cray/pe/mpt/7.7.20/gni/mpich-intel/16.0/include;/opt/cray/pe/libsci/22.05.1/INTEL/16.0/x86_64/include;/opt/cray/rca/2.2.22-7.0.4.1_2.35__ged51428.ari/include;/opt/cray/gni-headers/default/include;/opt/cray/ugni/default/include;/opt/cray/udreg/default/include;/opt/cray/alps/6.6.67-7.0.4.1_2.36__gb91cd181.ari/include;/opt/cray/pe/pmi/5.0.17/include;/opt/cray/xpmem/default/include;/opt/cray/wlm_detect/1.3.3-7.0.4.1_2.18__g7109084.ari/include;/opt/cray/krca/2.2.8-7.0.4.1_2.26__g59af36e.ari/include;/opt/cray-hss-devel/9.0.0/include;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/python-2.7.12-qpantrl4lgx5jj32c6r54ztixgljem5c/include;/opt/intel/oneapi/mkl/2022.2.1/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/globus-toolkit-6.0.17-klqyvmmhxqsf77ita7vvlw3wgyire7df/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/ncl-6.6.2-lekqd2ieivfhsd3cr2spmm5hibfwatg7/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/nco-4.7.9-wrjhlc76ydejqa2atomybt6h2qh5xi3p/include;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/wgrib2-2.0.8-wmuvhcduakhxv2v23e3gqquhgtwzhyb4/include;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include/intel64;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include/icc;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/include;/usr/include/c++/7;/usr/include/c++/7/x86_64-suse-linux;/usr/include/c++/7/backward;/usr/local/include;/usr/lib64/gcc/x86_64-suse-linux/7/include;/usr/lib64/gcc/x86_64-suse-linux/7/include-fixed;/usr/include")
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "darshan;fmpich;mpichcxx;darshan;z;mpichcxx_intel;rt;ugni;pthread;pmi;imf;m;dl;sci_intel_mpi;sci_intel;imf;m;dl;mpich_intel;rt;ugni;pthread;pmi;imf;m;dl;pmi;pthread;alpslli;pthread;wlm_detect;alpsutil;pthread;rca;xpmem;ugni;pthread;udreg;sci_intel;imf;m;pthread;dl;hugetlbfs;stdc++;imf;m;ifcoremt;ifport;pthread;imf;svml;irng;stdc++;m;ipgo;decimal;stdc++;gcc;irc;svml;c;gcc;irc_s;dl;c")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/opt/cray/dmapp/default/lib64;/opt/cray/pe/mpt/7.7.20/gni/mpich-intel/16.0/lib;/opt/cray/pe/libsci/22.05.1/INTEL/16.0/x86_64/lib;/opt/cray/rca/2.2.22-7.0.4.1_2.35__ged51428.ari/lib64;/opt/cray/ugni/default/lib64;/opt/cray/udreg/default/lib64;/opt/cray/alps/6.6.67-7.0.4.1_2.36__gb91cd181.ari/lib64;/opt/cray/pe/pmi/5.0.17/lib64;/sw/gaea-cle7/darshan/3.2.1-1/runtime/lib;/opt/cray/xpmem/default/lib64;/opt/cray/wlm_detect/1.3.3-7.0.4.1_2.18__g7109084.ari/lib64;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/git-2.9.3-qvbxg2vs55dnnegneixfwnlgjelcpyiw/lib;/ncrc/sw/gaea/.swci/0-login/opt/spack/20180512/linux-sles12-x86_64/gcc-5.3.0/python-2.7.12-qpantrl4lgx5jj32c6r54ztixgljem5c/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/globus-toolkit-6.0.17-klqyvmmhxqsf77ita7vvlw3wgyire7df/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/ncl-6.6.2-lekqd2ieivfhsd3cr2spmm5hibfwatg7/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/nco-4.7.9-wrjhlc76ydejqa2atomybt6h2qh5xi3p/lib;/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/wgrib2-2.0.8-wmuvhcduakhxv2v23e3gqquhgtwzhyb4/lib;/opt/intel/oneapi/mkl/2022.2.1/lib/intel64;/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/lib/intel64_lin;/opt/intel/oneapi/compiler/2022.2.1/linux/lib;/usr/lib64/gcc/x86_64-suse-linux/7;/usr/lib64;/lib64;/usr/x86_64-suse-linux/lib;/lib;/usr/lib")
set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
