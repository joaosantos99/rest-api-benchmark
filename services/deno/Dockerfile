# services/deno/Dockerfile
FROM denoland/deno:2.5.2-ubuntu AS base

WORKDIR /app

# Copy source code
COPY . .

EXPOSE 8080
CMD ["deno", "run", "--allow-net", "--allow-env", "index.ts"]
