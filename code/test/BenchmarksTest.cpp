#include <gtest/gtest.h>
#include <benchmarks.h>

using namespace Benchmarks;

namespace BenchmarksTests {
	class BenchmarksTest : public ::testing::Test {
	};

	TEST_F(BenchmarksTest, DefaultConstruction) {
		BenchmarkTests benchmark;
		const size_t defaultSize = 100000;
		EXPECT_EQ(benchmark.getBenchmarkArraySize(), defaultSize);

		const auto& vec = benchmark.getBenchmarkVector();
		EXPECT_EQ(vec.size(), defaultSize);
	}

	TEST_F(BenchmarksTest, ManualConstruction) {
		const size_t size = 250000;
		BenchmarkTests benchmark(size);
		const auto& vec = benchmark.getBenchmarkVector();

		EXPECT_EQ(benchmark.getBenchmarkArraySize(), size);
		EXPECT_EQ(vec.size(), size);
	}

	void test_set_benchmark_vector_size() {
		BenchmarkTests benchmark;
		const size_t size = 3000;

		benchmark.setBenchmarkArraySize(size);
		const auto& vec = benchmark.getBenchmarkVector();

		EXPECT_EQ(benchmark.getBenchmarkArraySize(), size);
		EXPECT_EQ(vec.size(), size);
	}
}