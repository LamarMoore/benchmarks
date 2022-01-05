# CMake version check.
cmake_minimum_required(VERSION 3.16)

# Define the project name.
project(Benchmarks)

# Policy settings
if(POLICY CMP0022)
  cmake_policy(SET CMP0022 NEW)
endif()

if(POLICY CMP0072)
  cmake_policy(SET CMP0072 OLD)
endif()

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

# System package target is important for the windows builds as it allows us to package only the dlls and exes and
# exclude libs. Defaults to empty for other platforms.
set(SYSTEM_PACKAGE_TARGET "")

# Add the path to our custom 'find' modules
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/config/CMake")
# Send libraries to common place, reference in several places so must be at top level
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)


set(CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}" "Benchmarks" "ALL" "/")

# Conda build variables
set(CONDA_ENV
    FALSE
    CACHE BOOL "If True then we are building in a conda environment.
          This predominately changes the operation of some the finders FindXXX.cmake
          On windows it also prevents the use of the 3rdparty dependency directory"
)
set(CONDA_BUILD
    FALSE
    CACHE
      BOOL
      "If True then we are using conda-build to build and package mantid.
          This stops a few things from occuring:
          - A bundle is no longer generated on OSX
          - Linux custom handling on the install is ommitted
          - Prevents site-package manipulation by the installer"
)

# Ensure that if we are running any sanitizers the compiler options are known in sub targets
include(Sanitizers)

# Packaging configuration
set(CPACK_PACKAGE_SUFFIX
    "unstable"
    CACHE STRING "suffix used to determine the deployment type"
)
set_property(CACHE CPACK_PACKAGE_SUFFIX PROPERTY STRINGS nightly unstable "")
# empty string and release are treated as the same thing
if(CPACK_PACKAGE_SUFFIX)
  # Camelcase version of suffix for Windows/Mac
  string(TOUPPER ${CPACK_PACKAGE_SUFFIX} CPACK_PACKAGE_SUFFIX_CAMELCASE)
  string(SUBSTRING ${CPACK_PACKAGE_SUFFIX_CAMELCASE} 0 1 CPACK_PACKAGE_SUFFIX_CAMELCASE)
  string(SUBSTRING ${CPACK_PACKAGE_SUFFIX} 1 -1 _tmp_suffix_remainder)
  string(CONCAT CPACK_PACKAGE_SUFFIX_CAMELCASE ${CPACK_PACKAGE_SUFFIX_CAMELCASE} ${_tmp_suffix_remainder})
endif()

# Set package name here
set(CPACK_PACKAGE_NAME "benchmarks${CPACK_PACKAGE_SUFFIX}")

# Bootstrap any dependencies
include(Bootstrap)

if(MSVC)
  include(MSVCSetup)
endif()

# Cross-platform setup
include(CommonSetup)

# Now add in all the components

# Set the path to the built docs directory here so that it can be used in the Kernel project for populating the
# properties file
set(DOCS_BUILDDIR ${CMAKE_BINARY_DIR}/docs)

# Framework Build options
option(CXXTEST_ADD_PERFORMANCE "Switch to add performance tests to the list of tests run by ctest?")

if(UNIX)
  # Experimental feature. Unix only at this point.
  option(UNITY_BUILD "Switch for utilising unity builds. Faster builds for selected components.")
endif(UNIX)

if(MSVC)
  add_definitions(-DQWT_DLL)
endif()

add_custom_target(AllTests)

add_subdirectory(code)

#TODO Build Docs with Sphinx

# Installation settings

# Install the files (.desktop and icon) to create a menu items
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux" AND NOT CONDA_BUILD)
  function(uppercase_first_letter output_var input)
    string(LENGTH ${input} _inputlen)
    string(TOUPPER ${input} _allupper)
    string(SUBSTRING ${_allupper} 0 1 _first)
    string(SUBSTRING ${input} 1 ${_inputlen} _rest)
    set(${output_var}
        ${_first}${_rest}
        PARENT_SCOPE
    )
  endfunction()

  function(install_desktop_files filename app_name exec_cmd icon_file icon_install_file)
    set(DESKTOP_NAME ${app_name})
    set(DESKTOP_EXEC_CMD ${exec_cmd})
    get_filename_component(DESKTOP_ICON ${icon_install_file} NAME_WE)
    set(_output_file ${CMAKE_CURRENT_BINARY_DIR}/${filename}.install)
    configure_file(
      ${CMAKE_CURRENT_SOURCE_DIR}/installers/LinuxInstaller/launcher-template.desktop.in ${_output_file} @ONLY
    )
    install(
      FILES ${_output_file}
      DESTINATION /usr/share/applications
      RENAME ${filename}
    )
    install(
      FILES ${icon_file}
      DESTINATION /usr/share/pixmaps
      RENAME ${icon_install_file}
    )
  endfunction()

  set(_icon_suffix)
  if(CPACK_PACKAGE_SUFFIX)
    if(${CPACK_PACKAGE_SUFFIX} STREQUAL "nightly" OR ${CPACK_PACKAGE_SUFFIX} STREQUAL "unstable")
      set(_icon_suffix ${CPACK_PACKAGE_SUFFIX})
    endif()
  endif()

  set(IMAGES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/images)
  set(_app_name_suffix)
  if(CPACK_PACKAGE_SUFFIX)
    uppercase_first_letter(_app_name_suffix ${CPACK_PACKAGE_SUFFIX})
  endif()

  if(ENABLE_WORKBENCH)
    set(_icon_filename ${IMAGES_DIR}/mantid_workbench)
    if(_icon_suffix)
      set(_icon_filename ${_icon_filename}${_icon_suffix})
    endif()
    install_desktop_files(
      mantidworkbench${CPACK_PACKAGE_SUFFIX}.desktop "Mantid Workbench ${_app_name_suffix}"
      ${CMAKE_INSTALL_PREFIX}/bin/mantidworkbench ${_icon_filename}.png mantid_workbench${CPACK_PACKAGE_SUFFIX}.png
    )
  endif()
endif()



# Conda
option(ENABLE_CONDA "Switch to enable conda package generation")
if(ENABLE_CONDA)
  include(conda)
endif(ENABLE_CONDA)

# CPack settings

# Keep this in a defaulted-to-off option
option(ENABLE_CPACK "Switch to enable CPack package generation")
if(ENABLE_CPACK)
  include(CPackCommon)

  #if(CMAKE_HOST_WIN32)
    #include(WindowsNSIS)

  # soft requirement of jemalloc if selected
  if(USE_JEMALLOC)
    message(STATUS "Adding jemalloc to the package requirements")
    set(CPACK_RPM_PACKAGE_REQUIRES "${CPACK_RPM_PACKAGE_REQUIRES}, jemalloc >= 3.0")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "${CPACK_DEBIAN_PACKAGE_DEPENDS}, libjemalloc1 (>= 3.0)")
  endif()

  # run cpack configuration
  include(CPack)
  # let people know what is coming out the other end - must be after cpack generates value for rpm
  message(STATUS "CPACK_PACKAGE_FILE_NAME = ${CPACK_PACKAGE_FILE_NAME}")
endif()