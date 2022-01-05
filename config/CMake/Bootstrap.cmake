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


