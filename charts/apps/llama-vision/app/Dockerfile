FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Expose Gradio default port
EXPOSE 7860

# Set environment variable for TGI URL (can be overridden at runtime)
ENV TGI_URL=http://localhost:80

# Run the application
CMD ["python", "app.py"]
