# services/rust/Dockerfile
FROM rust:1.80-bookworm AS builder

WORKDIR /app

# Copy source
COPY . .

# Set Rust flags for optimal performance
ENV RUSTFLAGS="-C target-cpu=native -C opt-level=3"

# Build the application
RUN cargo build --release

# Final minimal image
FROM ubuntu:24.04

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/server .

EXPOSE 8080
CMD ["./server"]
