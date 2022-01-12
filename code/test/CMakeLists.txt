if(CXXTEST_FOUND)
  include_directories(SYSTEM ${CXXTEST_INCLUDE_DIR})

  cxxtest_add_test(BenchmarksTest ${TEST_FILES})

  target_link_libraries(BenchmarksTest PRIVATE benchmarks PUBLIC GTest::gmock)
  
  set_property(TARGET BenchmarksTest PROPERTY FOLDER "UnitTests")
  
endif()

if(GTest_FOUND)
    add_executable(BenchmarksGTest BenchmarksGTest.cpp)
    
    target_link_libraries(BenchmarksGTest PRIVATE benchmarks PUBLIC GTest::gtest_main)
    
    set_property(TARGET BenchmarksGTest PROPERTY FOLDER "UnitTests")
    
    gtest_add_tests(TARGET BenchmarksGTest)
endif()