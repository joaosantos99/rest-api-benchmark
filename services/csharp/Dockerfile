# services/csharp/Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /app

# Copy project files
COPY CSharpBenchmark.csproj .
COPY src/ ./src/

# Restore dependencies and build
RUN dotnet restore
RUN dotnet build -c Release -o /app/out

# Final minimal image
FROM mcr.microsoft.com/dotnet/aspnet:7.0

WORKDIR /app

# Copy the built application
COPY --from=builder /app/out .

EXPOSE 8080

# Set environment variable for port
ENV ASPNETCORE_URLS=http://+:8080

CMD ["dotnet", "CSharpBenchmark.dll"]
