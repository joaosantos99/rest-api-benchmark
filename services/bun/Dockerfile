# services/bun/Dockerfile
FROM oven/bun:1.2.22 AS base

WORKDIR /app

# Copy source
COPY src/ .

# Optional: preinstall deps if package.json exists
RUN if [ -f package.json ]; then bun install; fi

EXPOSE 8080
CMD ["bun", "index.ts"]
