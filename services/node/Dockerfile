# services/node/Dockerfile
FROM node:20-alpine AS base

WORKDIR /app

# Copy source
COPY src/ .

EXPOSE 8080
CMD ["node", "index.js"]
