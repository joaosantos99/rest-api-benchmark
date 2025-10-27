#!/usr/bin/env bash

# REST API Benchmarks - Setup Script
# This script helps you set up the benchmarking environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SKIP_SYSTEM_TUNE=false
SKIP_DEPS_CHECK=false
BUILD_ALL=true
RUN_SAMPLE=false

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    cat << EOF
REST API Benchmarks Setup Script

USAGE:
    ./scripts/setup.sh [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    --skip-system-tune      Skip system tuning (sysctl modifications)
    --skip-deps-check       Skip dependency checks
    --no-build             Don't build Docker images
    --run-sample           Run a sample benchmark after setup
    
EXAMPLES:
    ./scripts/setup.sh                    # Full setup with all options
    ./scripts/setup.sh --skip-system-tune # Setup without system tuning
    ./scripts/setup.sh --run-sample       # Setup and run sample test

REQUIREMENTS:
    - Docker 20.10+
    - Docker Compose v2.0+
    - K6 0.40+
    - 8GB+ RAM recommended
    - Linux/macOS/Windows (WSL2)

EOF
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 is not installed or not in PATH"
        return 1
    fi
    return 0
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing_deps=()
    
    # Check Docker
    if ! check_command "docker"; then
        missing_deps+=("docker")
    else
        # Check Docker version
        local docker_version
        docker_version=$(docker --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        log_info "Docker version: $docker_version"
    fi
    
    # Check Docker Compose
    if ! docker compose version &> /dev/null; then
        if ! check_command "docker-compose"; then
            missing_deps+=("docker-compose")
        else
            log_warning "Using legacy docker-compose. Consider upgrading to Docker Compose v2"
        fi
    else
        local compose_version
        compose_version=$(docker compose version --short)
        log_info "Docker Compose version: $compose_version"
    fi
    
    # Check K6
    if ! check_command "k6"; then
        missing_deps+=("k6")
    else
        local k6_version
        k6_version=$(k6 version --short 2>/dev/null || k6 version | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        log_info "K6 version: $k6_version"
    fi
    
    # Check Node.js (optional, for result processing)
    if check_command "node"; then
        local node_version
        node_version=$(node --version)
        log_info "Node.js version: $node_version"
    else
        log_warning "Node.js not found - result summarization may not work"
    fi
    
    # Check Make (optional)
    if check_command "make"; then
        log_info "Make is available"
    else
        log_warning "Make not found - you'll need to run commands manually"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Please install missing dependencies:"
        
        for dep in "${missing_deps[@]}"; do
            case $dep in
                "docker")
                    log_info "  Docker: https://docs.docker.com/get-docker/"
                    ;;
                "docker-compose")
                    log_info "  Docker Compose: https://docs.docker.com/compose/install/"
                    ;;
                "k6")
                    log_info "  K6: https://k6.io/docs/getting-started/installation/"
                    log_info "    macOS: brew install k6"
                    log_info "    Ubuntu: sudo apt-get install k6"
                    ;;
            esac
        done
        
        return 1
    fi
    
    log_success "All required dependencies are installed"
    return 0
}

check_system_resources() {
    log_info "Checking system resources..."
    
    # Check available memory
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local mem_gb
        mem_gb=$(free -g | awk '/^Mem:/{print $2}')
        log_info "Available memory: ${mem_gb}GB"
        
        if [ "$mem_gb" -lt 8 ]; then
            log_warning "Less than 8GB RAM available. Performance may be affected."
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        local mem_gb
        mem_gb=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
        log_info "Available memory: ${mem_gb}GB"
        
        if [ "$mem_gb" -lt 8 ]; then
            log_warning "Less than 8GB RAM available. Performance may be affected."
        fi
    fi
    
    # Check disk space
    local disk_space
    disk_space=$(df -h . | awk 'NR==2{print $4}')
    log_info "Available disk space: $disk_space"
    
    # Check Docker daemon
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        return 1
    fi
    
    log_success "System resources check completed"
    return 0
}

system_tune() {
    log_info "Applying system tuning for optimal benchmarking..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ "$EUID" -eq 0 ]; then
            log_warning "Running as root. Applying system tuning directly."
            bash utils/sysctl.sh
        else
            log_info "Applying system tuning (requires sudo)..."
            if sudo -n true 2>/dev/null; then
                sudo bash utils/sysctl.sh
            else
                log_warning "Sudo required for system tuning. Skipping."
                log_info "You can run 'make tune' or 'sudo bash utils/sysctl.sh' manually later"
                return 0
            fi
        fi
        log_success "System tuning applied"
    else
        log_warning "System tuning is only supported on Linux. Skipping."
    fi
}

build_images() {
    log_info "Building Docker images..."
    
    # Check if we should use make or docker compose directly
    if command -v make &> /dev/null && [ -f Makefile ]; then
        log_info "Using Makefile for build..."
        make build
    else
        log_info "Using docker compose directly..."
        docker compose build
    fi
    
    log_success "Docker images built successfully"
}

create_results_directory() {
    log_info "Creating results directory structure..."
    
    mkdir -p results/{raw,summary}
    
    # Create .gitkeep files to preserve directory structure
    touch results/raw/.gitkeep
    touch results/summary/.gitkeep
    
    log_success "Results directory structure created"
}

run_sample_test() {
    log_info "Running sample benchmark test..."
    
    export IMAGE="bench/node"
    export SERVICE="node"
    export TEST_MODE="hello"
    export CPUS="1"
    export MEM="2g"
    export CPUSET="0"
    export HOST_PORT=18080
    
    log_info "Starting Node.js hello-world test..."
    docker compose up --build -d sut
    
    # Wait for service to be ready
    sleep 3
    
    # Check if service is responding
    if curl -f http://localhost:18080/api/hello-world &> /dev/null; then
        log_success "Service is responding"
        
        # Run a quick K6 test
        log_info "Running quick K6 test (10 VUs for 10 seconds)..."
        VUS=10 DURATION=10s TARGET_URL="http://127.0.0.1:18080/api/hello-world" k6 run k6/http-bench.js
        
        log_success "Sample test completed"
    else
        log_error "Service is not responding"
    fi
    
    # Clean up
    docker compose down -v
}

validate_setup() {
    log_info "Validating setup..."
    
    # Check if images were built
    local images
    images=$(docker images --format "table {{.Repository}}:{{.Tag}}" | grep "bench/" | wc -l)
    
    if [ "$images" -gt 0 ]; then
        log_success "Found $images benchmark images"
    else
        log_warning "No benchmark images found. Build may have failed."
    fi
    
    # Check if results directory exists
    if [ -d "results" ]; then
        log_success "Results directory exists"
    else
        log_warning "Results directory not found"
    fi
    
    log_success "Setup validation completed"
}

main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --skip-system-tune)
                SKIP_SYSTEM_TUNE=true
                shift
                ;;
            --skip-deps-check)
                SKIP_DEPS_CHECK=true
                shift
                ;;
            --no-build)
                BUILD_ALL=false
                shift
                ;;
            --run-sample)
                RUN_SAMPLE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    log_info "Starting REST API Benchmarks setup..."
    
    # Check if we're in the right directory
    if [ ! -f "compose.yml" ] || [ ! -f "Makefile" ]; then
        log_error "Please run this script from the repository root directory"
        exit 1
    fi
    
    # Dependency checks
    if [ "$SKIP_DEPS_CHECK" = false ]; then
        if ! check_dependencies; then
            exit 1
        fi
        
        if ! check_system_resources; then
            exit 1
        fi
    else
        log_warning "Skipping dependency checks"
    fi
    
    # System tuning
    if [ "$SKIP_SYSTEM_TUNE" = false ]; then
        system_tune
    else
        log_warning "Skipping system tuning"
    fi
    
    # Create directory structure
    create_results_directory
    
    # Build images
    if [ "$BUILD_ALL" = true ]; then
        build_images
    else
        log_warning "Skipping Docker image builds"
    fi
    
    # Validate setup
    validate_setup
    
    # Run sample test if requested
    if [ "$RUN_SAMPLE" = true ]; then
        run_sample_test
    fi
    
    log_success "Setup completed successfully!"
    
    # Show next steps
    echo
    log_info "Next steps:"
    echo "  1. Run full benchmark suite: make run"
    echo "  2. Run specific test: export IMAGE=bench/rust SERVICE=rust TEST_MODE=hello; docker compose up --build -d sut"
    echo "  3. Generate results summary: make summarize"
    echo "  4. Clean up: make clean"
    echo
    log_info "For more information, see the README.md file"
}

# Run main function
main "$@"
