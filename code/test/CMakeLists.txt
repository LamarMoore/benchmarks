if(GTest_FOUND)
    add_executable(BenchmarksTest ${TEST_FILES})
    
    target_link_libraries(BenchmarksTest PRIVATE benchmarks PUBLIC GTest::gtest_main)
    
    set_property(TARGET BenchmarksTest PROPERTY FOLDER "UnitTests")
    
    gtest_add_tests(TARGET BenchmarksTest)
endif()