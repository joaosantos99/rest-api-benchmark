# services/php/Dockerfile
FROM php:8.3-cli-alpine AS base

WORKDIR /app

# Copy source
COPY src/ .

EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "app.php"]
