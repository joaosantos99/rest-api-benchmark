# services/perl/Dockerfile
FROM perl:5.38-slim AS base

WORKDIR /app

# Install system dependencies and Perl modules
RUN apt-get update && apt-get install -y \
    build-essential \
    && cpanm --notest Plack HTTP::Server::PSGI JSON \
    && rm -rf /var/lib/apt/lists/*

# Copy source
COPY src/ .

EXPOSE 8080
CMD ["perl", "app.pl"]
