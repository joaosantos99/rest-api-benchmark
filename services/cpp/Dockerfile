# services/cpp/Dockerfile
FROM ubuntu:24.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    libboost-all-dev \
    git \
    libasio-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Crow from source
WORKDIR /tmp
RUN git clone https://github.com/CrowCpp/Crow.git && \
    cd Crow && \
    mkdir build && cd build && \
    cmake .. -DCROW_BUILD_EXAMPLES=OFF -DCROW_BUILD_TESTS=OFF && \
    make install

WORKDIR /app

# Copy source
COPY . .

# Build the application
RUN mkdir build && cd build && \
    cmake .. && \
    make

# Final minimal image
FROM ubuntu:24.04

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    libboost-system1.74.0 \
    libboost-thread1.74.0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/server .

EXPOSE 8080
CMD ["./server"]
