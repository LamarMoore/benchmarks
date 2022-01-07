#pragma once

#include <cxxtest/TestSuite.h>
#include <benchmarks.h>

using namespace Benchmarks;

class BenchmarksTest : public CxxTest::TestSuite {
public:
	void test_default_construction() {
		BenchmarkTests benchmark;
		const size_t defaultSize = 100000;
		TS_ASSERT_EQUALS(benchmark.getBenchmarkArraySize(), defaultSize);
		
		const auto& vec = benchmark.getBenchmarkVector();
		TS_ASSERT_EQUALS(vec.size(), defaultSize);
	}

	void test_construction() {
		const size_t size = 250000;
		BenchmarkTests benchmark(size);
		const auto& vec = benchmark.getBenchmarkVector();

		TS_ASSERT_EQUALS(benchmark.getBenchmarkArraySize(), size);
		TS_ASSERT_EQUALS(vec.size(), size);
	}

	void test_set_benchmark_vector_size() {
		BenchmarkTests benchmark;
		const size_t size = 3000;

		benchmark.setBenchmarkArraySize(size);
		const auto& vec = benchmark.getBenchmarkVector();

		TS_ASSERT_EQUALS(benchmark.getBenchmarkArraySize(), size);
		TS_ASSERT_EQUALS(vec.size(), size);
	}
};

class BenchmarksTestPerformance : public CxxTest::TestSuite {
public:
	void test_nothing() {
		TS_ASSERT(false);
	}
};