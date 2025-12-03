# services/java17/Dockerfile
FROM eclipse-temurin:17-jre-alpine AS builder

WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy source
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Final minimal image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/rest-api-benchmark-java17-1.0.0.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
