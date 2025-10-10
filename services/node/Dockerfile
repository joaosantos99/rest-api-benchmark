# services/node/Dockerfile
FROM node:20-alpine AS base

WORKDIR /app

# Copy source
COPY . .

# Optional: preinstall deps if package.json exists
RUN if [ -f package.json ]; then npm ci; fi

EXPOSE 8080
CMD ["node", "src/index.js"]
