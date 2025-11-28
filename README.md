# REST API Benchmarks

A comprehensive performance benchmarking suite comparing REST API implementations across multiple programming languages and frameworks.

## 🚀 Quick Start

### Prerequisites

- **Docker** (with Docker Compose)
- **K6** (for load testing)
- **Node.js** (for result summarization)
- **Make** (optional, for convenience commands)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/joaosantos99/rest-api-benchmark
   cd rest-api-benchmark
   ```

2. **Install K6:**
   ```bash
   # macOS
   brew install k6

   # Ubuntu/Debian
   sudo apt-get install k6

   # Or download from: https://k6.io/docs/getting-started/installation/
   ```

3. **System Tuning (Optional but Recommended):**
   ```bash
   make tune
   # This runs system optimizations for better benchmark accuracy
   ```

### Running Benchmarks

1. **Build all services:**
   ```bash
   make build
   # or: docker compose build
   ```

2. **Run the complete benchmark suite:**
   ```bash
   make run
   # or: bash orchestration/run-suite.sh
   ```

3. **Generate summary reports:**
   ```bash
   make summarize
   # or: node utils/summarize.mjs
   ```

4. **Clean up:**
   ```bash
   make clean
   # Removes all containers and results
   ```

### Individual Service Testing

To test a specific language/service:

```bash
# Set environment variables
export IMAGE="bench/node"  # or bun, deno, golang, rust, python, etc.
export SERVICE="node"
export TEST_MODE="hello"   # or n-body, pi-digits
export CPUS="2"
export MEM="4g"
export CPUSET="0-1"
export HOST_PORT=18080

# Start the service
docker compose up --build -d sut

# Run K6 test
k6 run k6/http-bench.js

# Clean up
docker compose down -v
```

## 📊 Languages & Tests Matrix

**Legend:** ✅ Working | 🚧 Work In Progress | ❌ Not Implemented

| Language | Version | Hello World | N-Body | Pi Digits | JSON Serde | Regex Redux | Status |
|----------|---------|-------------|--------|-----------|------------|-------------|--------|
| Node.js | v22.20.0 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| Bun | v1.2.22 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| Deno | v2.5.2 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| Go | v1.25.1 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| Rust | v1.90.0 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| C++ | v23 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| C# | v13 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| Java 17 | v17 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| Java 21 | v21 | ✅ | ✅ | ✅ | ✅ | ❌ | Partial |
| Scala | v3.7.3 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| Python | v3.13.7 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| PHP | v8.4.13 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| Perl | v5.42.0 | ✅ | ✅ | ✅ | ❌ | ❌ | Partial |
| Elixir | v1.18 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |

## 🧪 Test Descriptions

### 1. Hello World
Simple HTTP endpoint returning a JSON response with "Hello, World!" message. Tests basic request/response overhead.

### 2. N-Body Simulation
Computational physics simulation calculating gravitational forces between celestial bodies. Tests CPU-intensive operations.

### 3. Pi Digits
Mathematical computation calculating digits of π using various algorithms. Tests mathematical computation performance.

### 4. JSON Serde
HTTP endpoint that performs JSON serialization and deserialization entirely in memory.

### 5. Regex Redux
Regular expression pattern matching and text processing operations. Tests string manipulation and regex engine performance.

## ⚙️ Benchmark Configuration

### Server Specifications
- **Host**: 8vCPU, 32GB RAM - Ubuntu Server 24.04.3 LTS
- **Containers**: Ubuntu 24.04 base image with resource constraints:
  - 1vCPU, 2GB RAM
  - 2vCPU, 4GB RAM
  - 4vCPU, 8GB RAM
- **CPU Pinning**: `--cpuset-cpus` for consistent performance
- **Memory Limits**: `-m` for controlled memory allocation

### Load Testing Scenarios

| Scenario | Virtual Users | Duration | Purpose |
|----------|---------------|----------|---------|
| Warmup | 5 | 60s | JIT warm-up, caching, cold start |
| Light Load | 1 | 60s | Single user baseline |
| Medium Load | 100 | 60s | Typical web application load |
| High Load | 1,000 | 60s | High-traffic scenarios |
| Very High Load | 5,000 | 60s | Stress testing |
| Extreme Load | 10,000 | 60s | Breaking point analysis |

**Total Runtime**: ~10.5 minutes per language per container configuration

## 📈 Metrics Collected

- **Throughput**: Requests per second (req/s)
- **Latency Distribution**: p50, p95, p99 percentiles
- **Memory Usage**: Peak and steady-state consumption
- **CPU Utilization**: Per vCPU container usage
- **Error Rate**: Timeouts, connection refused, HTTP errors
- **Response Time**: Average, minimum, maximum response times

## 🛠️ Tools & Technologies

- **[K6](https://k6.io/)**: Load testing and performance monitoring
- **[Docker](https://www.docker.com/)**: Containerization and resource isolation
- **[Docker Compose](https://docs.docker.com/compose/)**: Multi-container orchestration
- **Node.js**: Result processing and summarization

## 📁 Project Structure

```
rest-api-benchmark/
├── services/           # Language-specific implementations
│   ├── node/          # Node.js service
│   ├── bun/           # Bun service
│   ├── deno/          # Deno service
│   ├── golang/        # Go service
│   ├── rust/          # Rust service
│   ├── python/        # Python service
│   └── ...            # Other languages
├── k6/                # Load testing scripts
├── orchestration/     # Benchmark orchestration
├── results/           # Benchmark results
├── utils/             # Utility scripts
└── compose.yml        # Docker Compose configuration
```

## 🔧 Customization

### Adding New Languages
1. Create a new directory in `services/`
2. Implement the required test endpoints
3. Add Dockerfile and build configuration
4. Update the orchestration script

### Modifying Test Scenarios
Edit `k6/scenarios.json` to adjust:
- Virtual user counts
- Test durations
- Load patterns

### Resource Configuration
Modify `orchestration/run-suite.sh` to change:
- CPU/memory allocations
- Container configurations
- Test repetitions

## 📊 Results

Results are stored in `results/raw/` as JSON files containing detailed metrics. Use `make summarize` to generate human-readable reports.
