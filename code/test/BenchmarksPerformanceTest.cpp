#include <benchmark/benchmark.h>
#include <benchmarks.h>

using namespace Benchmarks;

namespace BenchmarksPerformance {
	static void BM_DefaultConstruction(benchmark::State& state) {
		for (auto _ : state) {
			BenchmarkTests bt;
		}
	}

	static void BM_Construction(benchmark::State& state) {
		for (auto _ : state) {
			BenchmarkTests bt(3000000);
		}
	}

	BENCHMARK(BM_DefaultConstruction);
	BENCHMARK(BM_Construction);
}