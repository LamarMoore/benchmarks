set(SRC_FILES src/benchmarks.cpp)

set(INC_FILES inc/benchmarks.h)

set(TEST_FILES benchmarkstest.h)


add_library(benchmarks STATIC ${SRC_FILES} ${INC_FILES})
# Set the name of the generated library
set_target_properties(benchmarks PROPERTIES OUTPUT_NAME benchmarks COMPILE_DEFINITIONS "IN_BENCHMARKS")

target_include_directories(benchmarks PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/inc)
target_link_libraries(benchmarks PUBLIC TBB::tbb TBB::tbbmalloc)


add_subdirectory(test)