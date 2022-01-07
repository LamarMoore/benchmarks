#include <thread>
#include <algorithm>
#include <boost/asio.hpp>


#include "benchmarks.h"

namespace {
	const size_t DEFAULT_SIZE = 100000;
}

namespace Benchmarks {
	BenchmarkTests::BenchmarkTests(): BenchmarkTests(DEFAULT_SIZE) {
	}

	BenchmarkTests::BenchmarkTests(const size_t arraySize) {
		setBenchmarkArraySize(arraySize);
	}

	const size_t BenchmarkTests::getBenchmarkArraySize() const {
		return m_benchmarkArraySize;
	}

	void BenchmarkTests::setBenchmarkArraySize(const size_t arraySize) {
		m_benchmarkArraySize = arraySize;
		m_benchmarkVector.resize(arraySize);
	}

	const std::vector<size_t>& BenchmarkTests::getBenchmarkVector() const {
		return m_benchmarkVector;
	}

}