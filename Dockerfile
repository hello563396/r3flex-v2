# Use an official Python runtime as a base image with minimal size
FROM python:3.11-slim-bookworm

# Set environment variables to ensure Python output is unbuffered (better for logging)
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set the container's working directory
WORKDIR /app

# Install system dependencies required for build (like git for cloning libraries) and security updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the dependency file first (this leverages Docker's cache layer)
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Create a non-root user to run the application for enhanced security
RUN useradd --create-home --shell /bin/bash proxyuser
USER proxyuser

# Copy the rest of the application code into the container
COPY --chown=proxyuser:proxyuser . .

# Expose the port the app will run on (common proxy ports are 8080, 8888, 8080 is used here)
EXPOSE 8080

# Command to run the application. This will be replaced by your main Python script.
CMD ["python", "main.py"]
