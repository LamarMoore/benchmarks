if(GTest_FOUND)
    add_executable(BenchmarksTest ${TEST_FILES})
    
    target_link_libraries(BenchmarksTest PRIVATE benchmarks PUBLIC GTest::gtest_main)
    
    set_property(TARGET BenchmarksTest PROPERTY FOLDER "UnitTests")
    
    gtest_add_tests(TARGET BenchmarksTest)
endif()

if(Benchmark_FOUND)
    add_executable(BenchmarksPerformanceTest ${BENCHMARK_FILES})
    
    target_link_libraries(BenchmarksPerformanceTest PRIVATE benchmarks PUBLIC benchmark::benchmark_main)
    
    set_property(TARGET BenchmarksPerformanceTest PROPERTY FOLDER "PerformanceTests")
endif()