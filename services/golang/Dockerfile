# services/go/Dockerfile
FROM golang:1.25.1-bookworm AS builder

WORKDIR /app

# Copy source and build
COPY . .
RUN go mod init bench || true
RUN go build -o server .

# Final minimal image
FROM ubuntu:24.04

WORKDIR /app

COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]
