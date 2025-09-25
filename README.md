# REST API Benchmarks
### Languages
1. Javascript
	1. Node.js v22.20.0
	2. Bun v1.2.22
	3. Deno v2.5.2
2. Python
	1. Python v2.7.18
	2. Python v3.13.7
3. PHP v8.4.13
4. Golang v1.25.1
5. Rust v1.90.0
6. C++ v23
7. C# v13
8. Java
	1. Java 17
	2. Java 21
	3. Java 23
9. Elixir v1.18
10. Perl v5.42.0
11. Scala v3.7.3
### Server Specs
-  8vCPU, 32GB RAM - Ubuntu Server 24.04.3 LTS
	- Containers (ubuntu:24.04):
		1. (1vCPU, 2GB RAM)
		2. (2vCPU, 4GB RAM)
		3. (4vCPU, 8GB RAM)
	- Pin CPUs --cpuset-cpus
	- Memory limits  -m
### Tests
1. Hello World
2. JSON Serve (with file reading & writting)
3. Pi Digits
4. n-bodys
5. regex-redux
### Runs Settings
1. Concurrency 5 | Time 60 seconds (Warmup run - JIT warm-up, caching, cold start issues)
2. 60 seconds break
3. Concurrency 1 | Time 60 seconds
4. 60 seconds break
5. Concurrency 100 | Time 60 seconds
6. 60 seconds break
7. Concurrency 1000 | Time 60 seconds
8. 60 seconds break
9. Concurrency 5000 | Time 60 seconds
10. 60 seconds break
11. Concurrency 10.000 | Time 60 seconds

Each run will take 10 minutes and 30 seconds
Each language will run 5 tests in 3 difference containers, that will take 2 hours and 45 minutes
For fairness each languages will run 3 times all tests on a locally and a fourth test (hello world only) over the internet
### Metrics
- **Throughput** (req/s)
- **Latency distribution** (p50/p95/p99)
- **Memory usage** (peak & steady state)
- **CPU utilisation** (per vCPU container)
- **Error rate** (timeouts, refused connections)
### Tools
- K6
- Docker
