# ######################################################################################################################
# Configure required dependencies if necessary
# ######################################################################################################################


# Print out where we are looking for 3rd party stuff
set(Python_FIND_REGISTRY NEVER)
# used in later parts for MSVC to bundle Python
set(MSVC_PYTHON_EXECUTABLE_DIR $ENV{CONDA_PREFIX})
set(THIRD_PARTY_BIN "$ENV{CONDA_PREFIX}/Library/bin;$ENV{CONDA_PREFIX}/Library/lib;${MSVC_PYTHON_EXECUTABLE_DIR}")
# Add to the path so that cmake can configure correctly without the user having to do it
set(ENV{PATH} "${THIRD_PARTY_BIN};$ENV{PATH}")
# Set PATH for custom command or target build steps. Avoids the need to make external PATH updates
set(CMAKE_MSVCIDE_RUN_PATH ${THIRD_PARTY_BIN})


# Clean out python variables set from a previous build so they can be rediscovered again
function(unset_cached_Python_variables)
  foreach(
    _var
    Python_INCLUDE_DIR
    Python_LIBRARY
    Python_NUMPY_INCLUDE_DIR
  )
    unset(${_var} CACHE)
  endforeach()
endfunction()

# Find python interpreter
set(MINIMUM_PYTHON_VERSION 3.6)
set(Python_EXECUTABLE $ENV{CONDA_PREFIX}/python.exe)

# If anything external uses find_package(PythonInterp) then make sure it finds the correct version and executable
set(PYTHON_EXECUTABLE ${Python_EXECUTABLE})
set(Python_ADDITIONAL_VERSIONS ${Python_VERSION_MAJOR}.${Python_VERSION_MINOR})

# Handle switching between previously configured Python verions
if(Python_INCLUDE_DIR AND NOT Python_INCLUDE_DIR MATCHES ".*${Python_VERSION_MAJOR}\.${Python_VERSION_MINOR}.*")
  message(STATUS "Python version has changed. Clearing previous Python configuration.")
  unset_cached_python_variables()
endif()

# What version of setuptools are we using?
execute_process(
  COMMAND ${Python_EXECUTABLE} -c "import setuptools;print(setuptools.__version__)"
  RESULT_VARIABLE _setuptools_version_check_result
  OUTPUT_VARIABLE Python_SETUPTOOLS_VERSION
  ERROR_VARIABLE _setuptools_version_check_error
)
if(NOT _setuptools_version_check_result EQUAL 0)
  message(FATAL_ERROR "Unable to determine setuptools version - erro no ${_setuptools_version_check_result}:\n" "    ${_setuptools_version_check_error}")
endif()