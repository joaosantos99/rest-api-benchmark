# Support

## Getting Help

Welcome to the REST API Benchmarks project! If you need help, please follow the appropriate channel below.

## 📚 First Steps

Before asking for help, please:

1. **Read the Documentation**

  - Check the [README.md](../README.md) for setup instructions
  - Review the [Contributing Guide](../CONTRIBUTING.md)
  - Browse existing [Issues](../../issues) and [Discussions](../../discussions)

2. **Search Existing Resources**

  - Search closed issues for similar problems
  - Check the [Wiki](../../wiki) if available
  - Review the troubleshooting section below

## 🐛 Reporting Bugs

Found a bug? Please use our issue templates:

1. **Use the Bug Report Template**

  - Click [here](../../issues/new?template=bug_report.md) to create a bug report
  - Provide detailed information about your environment
  - Include steps to reproduce the issue
  - Add relevant logs and error messages

2. **Performance Issues**

  - Use the [Performance Issue Template](../../issues/new?template=performance_issue.md)
  - Include detailed performance metrics
  - Specify your hardware configuration
  - Compare with expected performance

## 💡 Feature Requests

Have an idea for improvement?

1. **Check Existing Requests**

  - Search [existing feature requests](../../issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
  - Vote on existing requests that interest you

2. **Submit New Request**

  - Use the [Feature Request Template](../../issues/new?template=feature_request.md)
  - For new language implementations, use the [Language Implementation Template](../../issues/new?template=language_implementation.md)

## 🔧 Technical Support

### Quick Troubleshooting

**Common Issues:**

1. **Docker Build Failures**

  ```bash
  # Clear Docker cache
  docker system prune -a

  # Rebuild without cache
  docker compose build --no-cache
  ```

2. **K6 Installation Issues**

  ```bash
  # macOS
  brew install k6

  # Ubuntu/Debian
  sudo apt-get update
  sudo apt-get install k6
  ```

3. **Permission Errors**

  ```bash
  # Make scripts executable
  chmod +x orchestration/run-suite.sh
  chmod +x utils/sysctl.sh
  ```

4. **Port Conflicts**

  ```bash
  # Check if port 18080 is in use
  lsof -i :18080

  # Use different port
  export HOST_PORT=18081
  ```

5. **System Tuning Issues**

  ```bash
  # Check current limits
  ulimit -n

  # Apply tuning (requires sudo)
  make tune
  ```

### Environment-Specific Help

**System Requirements:**

- Docker 20.10+
- Docker Compose v2.0+
- K6 0.40+
- 8GB+ RAM recommended
- Linux/macOS/Windows (WSL2)

**Supported Languages:**

- Node.js v22.20.0
- Bun v1.2.22
- Deno v2.5.2
- Go v1.25.1
- Rust v1.90.0
- Python v3.13.7
- Java 17 & 21
- C++ v23
- C# v13
- Scala v3.7.3
- PHP v8.4.13
- Perl v5.42.0
- Elixir v1.18

## 📞 Contact Channels

### Primary Contact

- **Maintainer**: [@joaosantos99](https://github.com/joaosantos99)
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas

### Response Times

- **Bug Reports**: 1-3 business days
- **Feature Requests**: 1-2 weeks
- **Security Issues**: 24-48 hours (see <SECURITY.md>)

## 🤝 Community Guidelines

When asking for help:

1. **Be Respectful**: Treat all community members with respect
2. **Be Clear**: Provide clear, detailed descriptions
3. **Be Patient**: Maintainers are volunteers
4. **Be Helpful**: Help others when you can

## 📖 Documentation

### Available Documentation

- [Setup Guide](../README.md#quick-start)
- [Language Matrix](../README.md#languages--tests-matrix)
- [Test Descriptions](../README.md#test-descriptions)
- [Configuration Guide](../README.md#customization)

### External Resources

- [K6 Documentation](https://k6.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Performance Testing Best Practices](https://k6.io/docs/testing-guides/)

## 🆘 Emergency Support

For critical issues affecting production environments:

1. **Security Vulnerabilities**: Follow the [Security Policy](SECURITY.md)
2. **Critical Bugs**: Label issues with `critical` and provide immediate impact assessment
3. **Urgent Features**: Explain business impact and timeline requirements

## 📋 Support Checklist

Before opening an issue, please confirm:

- [ ] I've read the README and documentation
- [ ] I've searched existing issues
- [ ] I've tried basic troubleshooting steps
- [ ] I can reproduce the issue consistently
- [ ] I've included all required information
- [ ] I've used the appropriate issue template

## 💝 Contributing

Want to help others? Consider:

- Answering questions in issues and discussions
- Improving documentation
- Adding new language implementations
- Reporting bugs you encounter
- Suggesting improvements

See our [Contributing Guide](../CONTRIBUTING.md) for more details.

--------------------------------------------------------------------------------

Thank you for using REST API Benchmarks! We appreciate your feedback and contributions to making this project better.
