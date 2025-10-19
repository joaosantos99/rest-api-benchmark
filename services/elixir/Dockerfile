# services/elixir/Dockerfile
FROM elixir:1.17-otp-27-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache build-base

# Copy source
COPY . .

# Install dependencies and build
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    MIX_ENV=prod mix release

# Final minimal image
FROM elixir:1.17-otp-27-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Copy built application
COPY --from=builder /app/_build/prod/rel/elixir_benchmark/ .

EXPOSE 8080
CMD ["./bin/elixir_benchmark", "start"]
