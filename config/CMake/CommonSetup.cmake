# Make the default build type Release
if(NOT CMAKE_CONFIGURATION_TYPES)
  if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type selected, default to Release.")
    set(CMAKE_BUILD_TYPE
        Release
        CACHE STRING "Choose the type of build." FORCE
    )
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
  else()
    message(STATUS "Build type is " ${CMAKE_BUILD_TYPE})
  endif()
endif()

find_package(CxxTest)
if(CXXTEST_FOUND)
  add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND})
  make_directory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Testing)
  message(STATUS "Added target ('check') for unit tests")
else()
  message(STATUS "Could NOT find CxxTest - unit testing not available")
endif()

find_package(GTest)
enable_testing()

# We want shared libraries everywhere
set(BUILD_SHARED_LIBS On)

# This allows us to group targets logically in Visual Studio
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Look for stdint and add define if found
include(CheckIncludeFiles)
check_include_files(stdint.h stdint)
if(stdint)
  add_definitions(-DHAVE_STDINT_H)
endif(stdint)

# Configure a variable to hold the required test timeout value for all tests
set(TESTING_TIMEOUT
    300
    CACHE STRING "Timeout in seconds for each test (default 300=5minutes)"
)


# ######################################################################################################################
# Look for dependencies Do NOT add include_directories commands here. They will affect every target.
# ######################################################################################################################
set(BOOST_VERSION_REQUIRED 1.65.0)
set(Boost_NO_BOOST_CMAKE TRUE)
# Unless specified see if the boost169 package is installed
if(EXISTS /usr/lib64/boost169 AND NOT (BOOST_LIBRARYDIR OR BOOST_INCLUDEDIR))
  message(STATUS "Using boost169 package in /usr/lib64/boost169")
  set(BOOST_INCLUDEDIR /usr/include/boost169)
  set(BOOST_LIBRARYDIR /usr/lib64/boost169)
endif()
find_package(Boost ${BOOST_VERSION_REQUIRED} REQUIRED COMPONENTS date_time regex serialization filesystem system)
add_definitions(-DBOOST_ALL_DYN_LINK -DBOOST_ALL_NO_LIB -DBOOST_BIND_GLOBAL_PLACEHOLDERS)
# Need this defined globally for our log time values
add_definitions(-DBOOST_DATE_TIME_POSIX_TIME_STD_CONFIG)
# Silence issues with deprecated allocator methods in boost regex
add_definitions(-D_SILENCE_CXX17_OLD_ALLOCATOR_MEMBERS_DEPRECATION_WARNING)

# Required packages
find_package(TBB REQUIRED)



# ######################################################################################################################
# Look for OpenMP
# ######################################################################################################################
find_package(OpenMP COMPONENTS CXX)
if(OpenMP_CXX_FOUND)
  link_libraries(OpenMP::OpenMP_CXX)
endif()

# ######################################################################################################################
# Add linux-specific things
# ######################################################################################################################
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  include(LinuxSetup)
endif()

# ######################################################################################################################
# Set the c++ standard to 17 - cmake should do the right thing with msvc
# ######################################################################################################################
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ######################################################################################################################
# Add compiler options if using gcc
# ######################################################################################################################
if(CMAKE_COMPILER_IS_GNUCXX)
  include(GNUSetup)
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
  include(GNUSetup)
endif()

# ######################################################################################################################
# Configure clang-tidy if the tool is found
# ######################################################################################################################
include(ClangTidy)

# ######################################################################################################################
# Setup cppcheck
# ######################################################################################################################
include(CppCheckSetup)

# ######################################################################################################################
# Visibility Setting
# ######################################################################################################################
if(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_CXX_VISIBILITY_PRESET
      hidden
      CACHE STRING ""
  )
endif()

# ######################################################################################################################
# Bundles setting used for install commands if not set by something else e.g. Darwin
# ######################################################################################################################
if(NOT BUNDLES)
  set(BUNDLES "./")
endif()

# ######################################################################################################################
# Set an auto generate warning for .in files.
# ######################################################################################################################
set(AUTO_GENERATE_WARNING "/********** PLEASE NOTE! THIS FILE WAS AUTO-GENERATED FROM CMAKE.  ***********************/")

# ######################################################################################################################
# Setup pre-commit here as otherwise it will be overwritten by earlier pre-commit hooks being added
# ######################################################################################################################
option(ENABLE_PRECOMMIT "Enable pre-commit framework" ON)
if(ENABLE_PRECOMMIT)
  # Windows should use downloaded ThirdParty version of pre-commit.cmd Everybody else should find one in their PATH
  find_program(
    PRE_COMMIT_EXE
    NAMES pre-commit
    HINTS ~/.local/bin/ "${MSVC_PYTHON_EXECUTABLE_DIR}/Scripts/"
  )
  if(NOT PRE_COMMIT_EXE)
    message(FATAL_ERROR "Failed to find pre-commit")
  endif()

  if(WIN32)
    if(CONDA_ENV)
      execute_process(
        COMMAND "${PRE_COMMIT_EXE}" install --overwrite
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        RESULT_VARIABLE PRE_COMMIT_RESULT
      )
    else()
      execute_process(
        COMMAND "${PRE_COMMIT_EXE}.cmd" install --overwrite
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        RESULT_VARIABLE PRE_COMMIT_RESULT
      )
    endif()
    if(NOT PRE_COMMIT_RESULT EQUAL "0")
      message(FATAL_ERROR "Pre-commit install failed with ${PRE_COMMIT_RESULT}")
    endif()
    # Create pre-commit script wrapper to use mantid third party python for pre-commit
    if(NOT CONDA_ENV)
      file(RENAME "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit" "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit-script.py")
      file(
        WRITE "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit"
        "#!/usr/bin/env sh\n${MSVC_PYTHON_EXECUTABLE_DIR}/python.exe ${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit-script.py"
      )
    else()
      file(TO_CMAKE_PATH $ENV{CONDA_PREFIX} CONDA_SHELL_PATH)
      file(RENAME "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit" "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit-script.py")
      file(
        WRITE "${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit"
        "#!/usr/bin/env sh\n${CONDA_SHELL_PATH}/Scripts/wrappers/conda/python.bat ${PROJECT_SOURCE_DIR}/.git/hooks/pre-commit-script.py"
      )
    endif()
  else() # linux as osx
    execute_process(
      COMMAND bash -c "${PRE_COMMIT_EXE} install"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE STATUS
    )
    if(STATUS AND NOT STATUS EQUAL 0)
      message(
        FATAL_ERROR
          "Pre-commit tried to install itself into your repository, but failed to do so. Is it installed on your system?"
      )
    endif()
  endif()
else()
  message(AUTHOR_WARNING "Pre-commit not enabled by CMake, please enable manually.")
endif()

# ######################################################################################################################
# Set a flag to indicate that this script has been called
# ######################################################################################################################

set(COMMONSETUP_DONE TRUE)
