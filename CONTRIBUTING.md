# Contributing to REST API Benchmarks

Thank you for your interest in contributing to the REST API Benchmarks project! This guide will help you get started with contributing effectively.

## 🚀 Quick Start

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a feature branch
4. **Make** your changes
5. **Test** your implementation
6. **Submit** a pull request

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Language Implementation Guide](#language-implementation-guide)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Community](#community)

## 📜 Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 🏁 Getting Started

### Prerequisites

- **Docker** (with Docker Compose)
- **K6** for load testing
- **Node.js** (for result processing)
- **Make** (optional, for convenience commands)

### Quick Setup

```bash
git clone https://github.com/your-username/rest-api-benchmark.git
cd rest-api-benchmark
make tune    # Optional system tuning
make build   # Build all services
make run     # Run basic benchmark
```

## 🛠️ Development Setup

### Environment Setup

1. **Install dependencies:**

  ```bash
  # macOS
  brew install k6 docker node

  # Ubuntu/Debian
  sudo apt-get install k6 docker.io nodejs npm
  ```

2. **Verify installation:**

  ```bash
  docker --version
  k6 version
  node --version
  ```

3. **System tuning (recommended):**

  ```bash
  make tune  # Optimize system for benchmarking
  ```

### Repository Structure

```
rest-api-benchmark/
├── services/           # Language implementations
│   ├── node/          # Node.js service
│   ├── rust/          # Rust service
│   └── ...            # Other languages
├── k6/                # Load testing scripts
├── orchestration/     # Benchmark orchestration
├── results/           # Benchmark results
├── utils/             # Utility scripts
├── docs/              # Documentation
└── .github/           # GitHub workflows and templates
```

## 🤝 Contributing Guidelines

### Types of Contributions

We welcome the following types of contributions:

1. **🏗️ New Language Implementations**

  - Add support for new programming languages
  - Follow existing patterns and standards

2. **🧪 Test Implementations**

  - Complete missing tests (JSON Serde, Regex Redux)
  - Improve existing test accuracy

3. **📊 Benchmark Improvements**

  - Enhanced metrics collection
  - Better statistical analysis
  - More realistic load patterns

4. **🐛 Bug Fixes**

  - Fix implementation issues
  - Resolve Docker or orchestration problems

5. **📚 Documentation**

  - Improve setup instructions
  - Add methodology explanations
  - Create performance analysis guides

6. **🚀 Performance Optimizations**

  - Docker image optimizations
  - Compiler flag improvements
  - Framework upgrades

### Contribution Workflow

1. **Check existing issues** before starting work
2. **Create an issue** for new features or major changes
3. **Discuss** your approach in the issue comments
4. **Fork** and create a feature branch
5. **Implement** your changes
6. **Test** thoroughly
7. **Submit** a pull request

## 🔤 Language Implementation Guide

### Adding a New Language

1. **Create language directory:**

  ```bash
  mkdir services/your-language
  cd services/your-language
  ```

2. **Required files:**

  ```
  services/your-language/
  ├── Dockerfile              # Build and runtime configuration
  ├── src/                     # Source code
  │   ├── main.*              # Entry point
  │   └── tests/              # Test implementations
  │       ├── hello-world.*   # Simple response test
  │       ├── n-body.*        # Physics simulation
  │       ├── pi-digits.*     # Mathematical computation
  │       ├── json-serde.*    # JSON serialization
  │       └── regex-redux.*   # Regular expression processing
  └── README.md               # Language-specific documentation
  ```

3. **Required endpoints:**

  - `GET /api/hello-world` - Return "Hello World!"
  - `GET /api/n-body` - N-body physics simulation
  - `GET /api/pi-digits` - Calculate π digits
  - `GET /api/json-serde` - JSON serialization benchmark
  - `GET /api/regex-redux` - Regular expression benchmark

### Implementation Standards

#### Dockerfile Requirements

```docker
# Multi-stage build for optimal size
FROM language-builder AS builder
WORKDIR /app
# Build with optimizations
RUN build-command --optimization-flags

FROM minimal-runtime AS runtime
WORKDIR /app
COPY --from=builder /app/binary .
HEALTHCHECK --interval=10s CMD curl -f http://localhost:8080/health || exit 1
EXPOSE 8080
CMD ["./binary"]
```

#### Code Requirements

- **Port**: Read from `PORT` environment variable (default: 8080)
- **Error Handling**: Graceful error responses
- **Health Check**: Optional `/health` endpoint
- **Logging**: Minimal logging to stdout
- **Performance**: Use language's best practices

#### Algorithm Standards

All implementations must use **identical algorithms**:

- **N-Body**: Specified integration method and constants
- **Pi Digits**: Spigot algorithm with BigInt precision
- **JSON Serde**: Standardized dataset with 100 cycles
- **Regex Redux**: Specified patterns and input data

Refer to `docs/algorithms.md` for detailed specifications.

## ✅ Testing Requirements

### Manual Testing

```bash
# Test your language implementation
export IMAGE="bench/your-language"
export SERVICE="your-language" 
export TEST_MODE="hello"
export CPUS="1"
export MEM="2g"
export CPUSET="0"
export HOST_PORT=18080

docker compose up --build -d sut
curl http://localhost:18080/api/hello-world
docker compose down -v
```

### Validation Checklist

Before submitting:

- [ ] All 5 endpoints implemented and working
- [ ] Dockerfile optimized (multi-stage, minimal runtime)
- [ ] Health check responding correctly
- [ ] Consistent output format with reference implementations
- [ ] No memory leaks during sustained load
- [ ] Error handling for malformed requests
- [ ] Documentation updated

### Performance Testing

```bash
# Basic performance test
k6 run --vus 10 --duration 30s k6/http-bench.js

# Memory usage test
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## 🔄 Pull Request Process

### Before Submitting

1. **Update documentation** if needed
2. **Add tests** for new functionality
3. **Ensure code quality** follows language conventions
4. **Verify builds** pass in Docker
5. **Run benchmark tests** to verify performance

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New language implementation
- [ ] Bug fix
- [ ] Performance optimization
- [ ] Documentation update
- [ ] Test improvement

## Testing
- [ ] Manual testing completed
- [ ] Docker build successful
- [ ] Benchmark tests pass
- [ ] Memory usage verified

## Language Details (if applicable)
- Language: 
- Version:
- Framework:
- Key optimizations:

## Checklist
- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

### Review Process

1. **Automated checks** must pass
2. **Manual review** by maintainers
3. **Performance validation** for language implementations
4. **Documentation review** for accuracy
5. **Final approval** and merge

## 🐛 Issue Reporting

### Bug Reports

Use the **Bug Report** template with:

- Environment details (OS, Docker version)
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs or output

### Feature Requests

Use the **Feature Request** template with:

- Clear description of the feature
- Use case and motivation
- Proposed implementation approach
- Alternative solutions considered

### Performance Issues

Use the **Performance Issue** template with:

- Affected language(s)
- Test configuration
- Performance metrics
- Comparison data

## 📊 Benchmarking Best Practices

### System Preparation

```bash
# Optimize system for consistent results
sudo sysctl -w net.ipv4.ip_local_port_range="1024 65535"
sudo sysctl -w net.core.somaxconn=65535
ulimit -n 1048576
```

### Measurement Guidelines

- **Multiple runs**: Minimum 5 repetitions for statistical significance
- **Warmup period**: Extended warmup for JVM languages (5+ minutes)
- **System isolation**: Close unnecessary applications
- **Consistent environment**: Same hardware/OS for comparisons

### Result Validation

- **Coefficient of variation** < 20% for reliable measurements
- **Outlier detection** and handling
- **Statistical significance** testing for comparisons
- **Confidence intervals** for all reported metrics

## 🌟 Recognition

Contributors will be recognized in:

- **README.md** contributors section
- **Release notes** for significant contributions
- **GitHub contributors** page
- **Special mentions** for outstanding contributions

## 🆘 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Documentation**: Check `docs/` directory
- **Examples**: Reference existing language implementations

## 📝 Style Guides

### Code Style

- Follow each language's conventional style guide
- Use meaningful variable names
- Add comments for complex algorithms
- Keep functions focused and testable

### Commit Messages

```
type(scope): description

feat(rust): add regex-redux implementation
fix(docker): optimize image size for Java services
docs(readme): update installation instructions
perf(golang): enable compiler optimizations
```

### Documentation Style

- Use clear, concise language
- Include code examples
- Update table of contents
- Follow existing formatting

## 🔄 Release Process

1. **Version planning** with feature goals
2. **Development phase** with feature branches
3. **Testing phase** with comprehensive validation
4. **Documentation update** for new features
5. **Release preparation** with changelog
6. **Release deployment** with tags and artifacts

--------------------------------------------------------------------------------

Thank you for contributing to making programming language performance benchmarking more accurate and comprehensive! 🚀

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.
