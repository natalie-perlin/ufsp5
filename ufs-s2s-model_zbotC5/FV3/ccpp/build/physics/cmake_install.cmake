# Install script for directory: /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/physics

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/libccppphys.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ccppphys-config.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ccppphys-config.cmake"
         "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/CMakeFiles/Export/lib/cmake/ccppphys-config.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ccppphys-config-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ccppphys-config.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/CMakeFiles/Export/lib/cmake/ccppphys-config.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake" TYPE FILE FILES "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/CMakeFiles/Export/lib/cmake/ccppphys-config-release.cmake")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/gfs_typedefs.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/mo_cloud_optics.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/mo_optical_props.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_typedefs.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/mo_gas_concentrations.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/machine.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/mo_source_functions.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/module_radlw_parameters.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/module_radsw_parameters.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/mo_gas_optics_rrtmgp.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_coupled_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_coupled_time_vary_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_coupled_radiation_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_coupled_physics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_coupled_stochastics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_satmedmf_coupled_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_satmedmf_coupled_time_vary_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_satmedmf_coupled_radiation_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_satmedmf_coupled_physics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_2017_satmedmf_coupled_stochastics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_fast_physics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_time_vary_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_radiation_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_physics_cap.mod"
    "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/physics/ccpp_fv3_gfs_v15p2_coupled_stochastics_cap.mod"
    )
endif()

