set(SRC_FILES src/benchmarks.cpp)

set(INC_FILES inc/benchmarks.h)

set(TEST_FILES benchmarkstest.h)


add_executable(benchmarks ${SRC_FILES} ${INC_FILES})

target_include_directories(benchmarks PRIVATE ${TBB_INCLUDE_DIRECTORIES} ${BOOST_INCLUDEDIRS})
target_link_libraries(benchmarks PRIVATE ${Boost_LIBRARIES} ${TBB_LIBRARIES})