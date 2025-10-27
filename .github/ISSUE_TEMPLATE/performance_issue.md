---
name: Performance Issue
about: Report unexpected performance behavior or regression
title: '[PERF] '
labels:
  - performance
assignees: ''
---

# ⚡ Performance Issue Description

Brief description of the performance problem.

# 📊 Performance Data

## Current Performance

**Affected Test(s):**

- [ ] Hello World
- [ ] N-Body
- [ ] Pi Digits
- [ ] JSON Serde
- [ ] Regex Redux

**Language(s):** [e.g. Rust, Java 21, Python]

**Metrics:**

```
Throughput: [req/sec]
Latency p50: [ms]
Latency p95: [ms]
Latency p99: [ms]
Memory Usage: [MB]
CPU Usage: [%]
Error Rate: [%]
```

## Expected Performance

**Expected Metrics:**

```
Throughput: [req/sec]
Latency p50: [ms]
Latency p95: [ms]
Latency p99: [ms]
Memory Usage: [MB]
CPU Usage: [%]
```

**Baseline/Comparison:**

- Previous version: [Performance data]
- Similar language: [Performance data]
- Theoretical maximum: [Expected based on language characteristics]

# 🔄 Reproduction Steps

1. System configuration: [CPU, RAM, OS]
2. Docker configuration: [vCPU, memory limits]
3. K6 test scenario: [VUs, duration]
4. Commands run:

  ```bash
  [Exact commands to reproduce]
  ```

# 🌍 Environment Details

**Host System:**

- OS: [e.g. Ubuntu 22.04]
- CPU: [e.g. Intel i7-12700K @ 3.6GHz, 8 cores]
- RAM: [e.g. 32GB DDR4-3200]
- Storage: [e.g. NVMe SSD]

**Container Configuration:**

- CPU Limit: [e.g. 2 vCPU]
- Memory Limit: [e.g. 4GB]
- CPU Set: [e.g. 0-1]
- Network Mode: [bridge/host]

**Software Versions:**

- Docker: [version]
- K6: [version]
- Language Runtime: [version]

# 📈 Performance Analysis

## Resource Utilization

```
docker stats output:
CONTAINER   CPU %   MEM USAGE / LIMIT   MEM %   NET I/O   BLOCK I/O
service     [%]     [usage] / [limit]   [%]     [I/O]     [I/O]
```

## System Monitoring

**During performance issue:**

- Load average: [1min 5min 15min]
- Memory pressure: [free/available/swap usage]
- Disk I/O: [read/write IOPS]
- Network: [packets/sec, bandwidth]

## Potential Bottlenecks

- [ ] CPU bound
- [ ] Memory bound
- [ ] I/O bound
- [ ] Network bound
- [ ] Framework/library limitation
- [ ] Configuration issue
- [ ] Resource contention

# 🔍 Investigation Results

## Profiling Data

If you've done any profiling, include relevant data:

```
[CPU profiling output]
[Memory profiling output]
[Application-specific metrics]
```

## Log Analysis

**Application Logs:**

```
[Relevant log entries showing performance issues]
```

**System Logs:**

```
[dmesg, syslog entries if relevant]
```

## Comparative Analysis

**Performance vs Other Languages:**

- Faster than: [Languages and by how much]
- Slower than: [Languages and by how much]
- Expected ranking: [Where should this language rank?]

# 💡 Hypothesis

What do you think might be causing the performance issue?

**Potential Causes:**

- [ ] Compiler/runtime optimization issue
- [ ] Framework inefficiency
- [ ] Algorithm implementation problem
- [ ] Docker configuration
- [ ] System resource limitation
- [ ] Test implementation bug
- [ ] Measurement error

**Supporting Evidence:** [Why do you think this is the cause?]

# 🛠️ Attempted Solutions

What have you tried to resolve this issue?

- [ ] Different compiler/runtime flags
- [ ] Alternative framework or library
- [ ] Docker configuration changes
- [ ] System tuning modifications
- [ ] Code optimization attempts
- [ ] Different test scenarios

**Results of Attempts:** [What happened when you tried these solutions?]

# 📊 Regression Analysis

**Is this a regression?**

- [ ] Yes - performance was better before
- [ ] No - this is a new baseline measurement
- [ ] Unknown - no previous data

**If regression:**

- Last known good version/commit: [ID]
- Performance change: [X% slower/faster]
- Suspected cause: [Recent changes that might affect performance]

# 🎯 Performance Goals

**Target Performance:**

- Throughput: [target req/sec]
- Latency: [target p95 latency]
- Memory: [target memory usage]
- Ranking: [expected position relative to other languages]

**Acceptable Performance:**

- Minimum throughput: [req/sec]
- Maximum latency: [p95 latency]
- Maximum memory: [MB]

# 🔗 Related Information

**Similar Issues:**

- Link to related performance issues
- Benchmark results from other projects
- Academic papers or studies

**Reference Implementations:**

- Other benchmark suites with this language
- Official performance guidance
- Community best practices

--------------------------------------------------------------------------------

**Impact Assessment:**

- [ ] Critical - Affects benchmark validity
- [ ] High - Significant performance deviation
- [ ] Medium - Noticeable but acceptable
- [ ] Low - Minor optimization opportunity

**Urgency:**

- [ ] Immediate - Blocks current benchmarking
- [ ] High - Should be fixed soon
- [ ] Medium - Fix in next release
- [ ] Low - Enhancement for future

**Checklist:**

- [ ] I have provided comprehensive performance data
- [ ] I have attempted basic troubleshooting
- [ ] I have compared with other languages
- [ ] I have checked for recent changes
- [ ] I have included relevant logs and monitoring data
