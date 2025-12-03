# services/go/Dockerfile
FROM golang:1.25.1-bookworm AS builder

WORKDIR /app

# Copy source and build
COPY src/ .
RUN go mod init bench || true
# Set Go flags for optimal performance
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=7 GO111MODULE=on
# Build the application
RUN go build -a -ldflags '-extldflags "-static"' -o server

# Final minimal image
FROM ubuntu:24.04

WORKDIR /app

COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]
