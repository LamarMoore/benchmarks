if(CXXTEST_FOUND)
  include_directories(SYSTEM ${CXXTEST_INCLUDE_DIR})

  cxxtest_add_test(BenchmarksTest ${TEST_FILES} ${GMOCK_TEST_FILES})

  target_link_libraries(BenchmarksTest PRIVATE Benchmarks)

  # Add to the 'FrameworkTests' group in VS
  set_property(TARGET BenchmarksTest PROPERTY FOLDER "UnitTests")
endif()