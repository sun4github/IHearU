# Use NVIDIA's official CUDA 12.x runtime with Ubuntu 24.04
FROM nvidia/cuda:12.6.2-cudnn-runtime-ubuntu24.04

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-full \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Set Environment Variables for GPU libraries
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Copy application code
COPY main.py .

# Expose the port you chose
EXPOSE 9001

# Run the server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9001"]