# services/scala/Dockerfile
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Install sbt
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L -o sbt.deb https://repo.scala-sbt.org/scalasbt/debian/sbt-1.9.7.deb && \
    dpkg -i sbt.deb || apt-get install -f -y && \
    rm sbt.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy build files
COPY build.sbt project/build.properties ./
COPY project/ project/

# Copy source
COPY src/ src/

# Build the application
RUN sbt assembly

# Final minimal image
FROM eclipse-temurin:17-jre

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/scala-3.3.1/scala-benchmark.jar .

EXPOSE 8080
CMD ["java", "-jar", "scala-benchmark.jar"]
