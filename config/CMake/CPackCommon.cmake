# ######################################################################################################################
# Putting all the common CPack stuff in one place
# ######################################################################################################################

# Common description stuff
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Test DevOps Repo with benchmarking code")
set(CPACK_PACKAGE_VENDOR "Lamar Moore")


# RPM information - only used if generating a rpm the release number is an option set in LinuxPackageScripts.cmake
set(CPACK_RPM_PACKAGE_LICENSE GPLv3+)
set(CPACK_RPM_PACKAGE_GROUP Applications/Engineering)

# DEB information - the package does not have an original in debian archives so the debian release is 0
set(CPACK_DEBIAN_PACKAGE_RELEASE 0)
set(CPACK_DEBIAN_PACKAGE_CONTROL_STRICT_PERMISSION TRUE)
