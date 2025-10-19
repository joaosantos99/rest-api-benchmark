# services/python/Dockerfile
FROM python:3.12-alpine AS base

WORKDIR /app

# Copy requirements first for better caching
COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY src/ .

EXPOSE 8080
CMD ["python", "app.py"]
