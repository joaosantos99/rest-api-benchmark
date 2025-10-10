# services/bun/Dockerfile
FROM oven/bun:1.2.22 AS base

WORKDIR /app

# Copy source
COPY . .

# Optional: preinstall deps if package.json exists
RUN if [ -f package.json ]; then bun install --ci; fi

EXPOSE 8080
CMD ["bun", "src/index.ts"]
