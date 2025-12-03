# Security Policy

## Supported Versions

We actively support the following versions of the REST API Benchmarks project:

Version | Supported
------- | ------------------
Latest  | :white_check_mark:
< 1.0   | :x:

## Reporting a Vulnerability

The security of this project is important to us. If you discover a security vulnerability, please follow these steps:

### 1\. **Do Not** Create a Public Issue

Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2\. Report Privately

Send an email to: **security@[your-domain].com** (replace with actual email)

Include the following information:

- Type of vulnerability
- Steps to reproduce the vulnerability
- Affected versions
- Potential impact
- Suggested fix (if available)

### 3\. Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution Timeline**: Varies based on complexity

### 4\. Disclosure Policy

- We will acknowledge receipt of your vulnerability report
- We will provide an estimated timeline for addressing the vulnerability
- We will notify you when the vulnerability has been fixed
- We will credit you in our security advisories (unless you prefer to remain anonymous)

## Security Best Practices

When using this benchmarking suite:

### For Contributors

- Keep dependencies updated
- Use official base images in Dockerfiles
- Avoid hardcoding sensitive information
- Follow secure coding practices
- Validate all inputs

### For Users

- Run benchmarks in isolated environments
- Keep Docker and system dependencies updated
- Monitor resource usage during benchmarks
- Use trusted base images
- Review code before running in production environments

## Security Considerations

### Docker Security

- All containers run with limited privileges
- Use official language runtime images
- Regular base image updates
- No sensitive data in containers

### Network Security

- Benchmarks use localhost/container networking
- No external network dependencies during tests
- K6 load testing is isolated

### Data Security

- No sensitive data is processed
- All test data is synthetic
- Results contain only performance metrics

## Vulnerability Response Process

1. **Triage**: Assess severity and impact
2. **Investigation**: Reproduce and analyze the vulnerability
3. **Fix Development**: Create and test a fix
4. **Testing**: Verify the fix doesn't break functionality
5. **Release**: Deploy fix and notify stakeholders
6. **Disclosure**: Publish security advisory if appropriate

## Contact

For security-related questions or concerns:

- Email: security@[your-domain].com
- Maintainer: @joaosantos99

## Security Tools

We use the following tools to maintain security:

- Dependabot for dependency updates
- GitHub Security Advisories
- Container vulnerability scanning
- Static code analysis

Thank you for helping keep the REST API Benchmarks project secure!
