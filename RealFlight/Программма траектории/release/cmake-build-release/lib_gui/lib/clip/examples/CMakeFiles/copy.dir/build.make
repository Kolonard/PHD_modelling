# CMAKE generated file: DO NOT EDIT!
# Generated by "NMake Makefiles" Generator, CMake Version 3.20

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE
NULL=nul
!ENDIF
SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\JetBrains\CLion 2021.1.3\bin\cmake\win\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\JetBrains\CLion 2021.1.3\bin\cmake\win\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\Users\cel\dev\bitbucket\softael\trajectory

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release

# Include any dependencies generated for this target.
include lib_gui\lib\clip\examples\CMakeFiles\copy.dir\depend.make
# Include the progress variables for this target.
include lib_gui\lib\clip\examples\CMakeFiles\copy.dir\progress.make

# Include the compile flags for this target's objects.
include lib_gui\lib\clip\examples\CMakeFiles\copy.dir\flags.make

lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.obj: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\flags.make
lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.obj: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\includes_CXX.rsp
lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.obj: ..\lib_gui\lib\clip\examples\copy.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object lib_gui/lib/clip/examples/CMakeFiles/copy.dir/copy.cpp.obj"
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples
	C:\PROGRA~2\MICROS~2\2019\COMMUN~1\VC\Tools\Llvm\x64\bin\CLANG_~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles\copy.dir\copy.cpp.obj -c C:\Users\cel\dev\bitbucket\softael\trajectory\lib_gui\lib\clip\examples\copy.cpp
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release

lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/copy.dir/copy.cpp.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CXX_CREATE_PREPROCESSED_SOURCE

lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/copy.dir/copy.cpp.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CXX_CREATE_ASSEMBLY_SOURCE

# Object files for target copy
copy_OBJECTS = \
"CMakeFiles\copy.dir\copy.cpp.obj"

# External object files for target copy
copy_EXTERNAL_OBJECTS =

lib_gui\lib\clip\examples\copy.exe: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\copy.cpp.obj
lib_gui\lib\clip\examples\copy.exe: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\build.make
lib_gui\lib\clip\examples\copy.exe: lib_gui\lib\clip\clip.lib
lib_gui\lib\clip\examples\copy.exe: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\linklibs.rsp
lib_gui\lib\clip\examples\copy.exe: lib_gui\lib\clip\examples\CMakeFiles\copy.dir\objects1.rsp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable copy.exe"
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples
	C:\PROGRA~2\MICROS~2\2019\COMMUN~1\VC\Tools\Llvm\x64\bin\CLANG_~1.EXE -fuse-ld=lld-link -nostartfiles -nostdlib  -std=c++17 -Wno-write-strings -Wno-format-security -Wno-int-to-void-pointer-cast -Wno-deprecated-declarations -std=c++17 -Wno-write-strings -Wno-format-security -Wno-int-to-void-pointer-cast -Wno-deprecated-declarations -O3 -DNDEBUG -D_DLL -D_MT -Xclang --dependent-lib=msvcrt -Xlinker /subsystem:console @CMakeFiles\copy.dir\objects1.rsp -o copy.exe -Xlinker /implib:copy.lib -Xlinker /pdb:C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples\copy.pdb -Xlinker /version:0.0  @CMakeFiles\copy.dir\linklibs.rsp
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release

# Rule to build all files generated by this target.
lib_gui\lib\clip\examples\CMakeFiles\copy.dir\build: lib_gui\lib\clip\examples\copy.exe
.PHONY : lib_gui\lib\clip\examples\CMakeFiles\copy.dir\build

lib_gui\lib\clip\examples\CMakeFiles\copy.dir\clean:
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples
	$(CMAKE_COMMAND) -P CMakeFiles\copy.dir\cmake_clean.cmake
	cd C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release
.PHONY : lib_gui\lib\clip\examples\CMakeFiles\copy.dir\clean

lib_gui\lib\clip\examples\CMakeFiles\copy.dir\depend:
	$(CMAKE_COMMAND) -E cmake_depends "NMake Makefiles" C:\Users\cel\dev\bitbucket\softael\trajectory C:\Users\cel\dev\bitbucket\softael\trajectory\lib_gui\lib\clip\examples C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples C:\Users\cel\dev\bitbucket\softael\trajectory\cmake-build-release\lib_gui\lib\clip\examples\CMakeFiles\copy.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : lib_gui\lib\clip\examples\CMakeFiles\copy.dir\depend

