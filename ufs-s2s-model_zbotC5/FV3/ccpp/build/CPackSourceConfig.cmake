# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


set(CPACK_BUILD_SOURCE_DIRS "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp;/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build")
set(CPACK_CMAKE_GENERATOR "Unix Makefiles")
set(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
set(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_FILE "/ncrc/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/cmake-3.17.0-l3ny7z55qqxs6aov7cm4h5zfe3n4tljy/share/cmake-3.17/Templates/CPack.GenericDescription.txt")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_SUMMARY "CCPP-FV3 built using CMake")
set(CPACK_GENERATOR "TBZ2")
set(CPACK_IGNORE_FILES "/CVS/;/\\.svn/;/\\.bzr/;/\\.hg/;/\\.git/;\\.swp\$;\\.#;/#")
set(CPACK_INSTALLED_DIRECTORIES "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp;/")
set(CPACK_INSTALL_CMAKE_PROJECTS "")
set(CPACK_INSTALL_PREFIX "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp")
set(CPACK_MODULE_PATH "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/cmake;/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/cmake")
set(CPACK_NSIS_DISPLAY_NAME "CMake .")
set(CPACK_NSIS_INSTALLER_ICON_CODE "")
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
set(CPACK_NSIS_PACKAGE_NAME "CMake .")
set(CPACK_NSIS_UNINSTALL_NAME "Uninstall")
set(CPACK_OUTPUT_CONFIG_FILE "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CPackConfig.cmake")
set(CPACK_PACKAGE_DEFAULT_LOCATION "/")
set(CPACK_PACKAGE_DESCRIPTION_FILE "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/README.md")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Common Community Physics Package - Framework")
set(CPACK_PACKAGE_FILE_NAME "CCPP-FV3-4.0.0")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake .")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "CMake .")
set(CPACK_PACKAGE_NAME "CCPP-FV3")
set(CPACK_PACKAGE_RELOCATABLE "true")
set(CPACK_PACKAGE_VENDOR "GMTB NOAA/NCAR")
set(CPACK_PACKAGE_VERSION "4.0.0")
set(CPACK_PACKAGE_VERSION_MAJOR "4")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_RESOURCE_FILE_LICENSE "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/LICENSE")
set(CPACK_RESOURCE_FILE_README "/ncrc/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/cmake-3.17.0-l3ny7z55qqxs6aov7cm4h5zfe3n4tljy/share/cmake-3.17/Templates/CPack.GenericDescription.txt")
set(CPACK_RESOURCE_FILE_WELCOME "/ncrc/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/cmake-3.17.0-l3ny7z55qqxs6aov7cm4h5zfe3n4tljy/share/cmake-3.17/Templates/CPack.GenericWelcome.txt")
set(CPACK_RPM_PACKAGE_SOURCES "ON")
set(CPACK_SET_DESTDIR "OFF")
set(CPACK_SOURCE_GENERATOR "TBZ2")
set(CPACK_SOURCE_IGNORE_FILES "/CVS/;/\\.svn/;/\\.bzr/;/\\.hg/;/\\.git/;\\.swp\$;\\.#;/#")
set(CPACK_SOURCE_INSTALLED_DIRECTORIES "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp;/")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CPackSourceConfig.cmake")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "CCPP-FV3-4.0.0")
set(CPACK_SOURCE_TOPLEVEL_TAG "Linux-Source")
set(CPACK_STRIP_FILES "")
set(CPACK_SYSTEM_NAME "Linux")
set(CPACK_TOPLEVEL_TAG "Linux-Source")
set(CPACK_WIX_SIZEOF_VOID_P "8")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()
