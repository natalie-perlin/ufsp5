# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /ncrc/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/cmake-3.17.0-l3ny7z55qqxs6aov7cm4h5zfe3n4tljy/bin/cmake

# The command to remove a file.
RM = /ncrc/sw/gaea-cle7/uasw/ncrc/envs/20200417/opt/linux-sles15-x86_64/gcc-7.5.0/cmake-3.17.0-l3ny7z55qqxs6aov7cm4h5zfe3n4tljy/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build

# Include any dependencies generated for this target.
include framework/src/CMakeFiles/ccpp.dir/depend.make

# Include the progress variables for this target.
include framework/src/CMakeFiles/ccpp.dir/progress.make

# Include the compile flags for this target's objects.
include framework/src/CMakeFiles/ccpp.dir/flags.make

framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.o: framework/src/CMakeFiles/ccpp.dir/flags.make
framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.o: ../framework/src/ccpp_types.F90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.o"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_types.F90 -o CMakeFiles/ccpp.dir/ccpp_types.F90.o

framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/ccpp.dir/ccpp_types.F90.i"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_types.F90 > CMakeFiles/ccpp.dir/ccpp_types.F90.i

framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/ccpp.dir/ccpp_types.F90.s"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_types.F90 -o CMakeFiles/ccpp.dir/ccpp_types.F90.s

framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.o: framework/src/CMakeFiles/ccpp.dir/flags.make
framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.o: ../framework/src/ccpp_api.F90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building Fortran object framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.o"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_api.F90 -o CMakeFiles/ccpp.dir/ccpp_api.F90.o

framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/ccpp.dir/ccpp_api.F90.i"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_api.F90 > CMakeFiles/ccpp.dir/ccpp_api.F90.i

framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/ccpp.dir/ccpp_api.F90.s"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && /opt/cray/pe/craype/2.7.15/bin/ftn $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src/ccpp_api.F90 -o CMakeFiles/ccpp.dir/ccpp_api.F90.s

# Object files for target ccpp
ccpp_OBJECTS = \
"CMakeFiles/ccpp.dir/ccpp_types.F90.o" \
"CMakeFiles/ccpp.dir/ccpp_api.F90.o"

# External object files for target ccpp
ccpp_EXTERNAL_OBJECTS =

framework/src/libccpp.a: framework/src/CMakeFiles/ccpp.dir/ccpp_types.F90.o
framework/src/libccpp.a: framework/src/CMakeFiles/ccpp.dir/ccpp_api.F90.o
framework/src/libccpp.a: framework/src/CMakeFiles/ccpp.dir/build.make
framework/src/libccpp.a: framework/src/CMakeFiles/ccpp.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking Fortran static library libccpp.a"
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && $(CMAKE_COMMAND) -P CMakeFiles/ccpp.dir/cmake_clean_target.cmake
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ccpp.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
framework/src/CMakeFiles/ccpp.dir/build: framework/src/libccpp.a

.PHONY : framework/src/CMakeFiles/ccpp.dir/build

framework/src/CMakeFiles/ccpp.dir/clean:
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src && $(CMAKE_COMMAND) -P CMakeFiles/ccpp.dir/cmake_clean.cmake
.PHONY : framework/src/CMakeFiles/ccpp.dir/clean

framework/src/CMakeFiles/ccpp.dir/depend:
	cd /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/framework/src /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/FV3/ccpp/build/framework/src/CMakeFiles/ccpp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : framework/src/CMakeFiles/ccpp.dir/depend

