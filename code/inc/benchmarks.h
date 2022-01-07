#pragma once

#include <vector>

namespace Benchmarks {

	class BenchmarkTests {
	public:
		BenchmarkTests();
		BenchmarkTests(const size_t arraySize);

		// initialise 
		void setBenchmarkArraySize(const size_t arraySize);
		const size_t getBenchmarkArraySize() const;
		const std::vector<size_t>& getBenchmarkVector() const;

		// benchmarks
	private:
		size_t m_benchmarkArraySize;
		std::vector<size_t> m_benchmarkVector;
	};

}// namespace Benchmarks