# services/deno/Dockerfile
FROM denoland/deno:ubuntu AS base

WORKDIR /app

# Copy source code
COPY src/ .

EXPOSE 8080
CMD ["deno", "run", "--allow-net", "--allow-env", "index.ts"]
