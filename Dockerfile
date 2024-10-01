# Use a Python base image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the necessary files to the container
COPY entrypoint.sh /app/entrypoint.sh
COPY node.py /app/node.py
COPY node.json /app/node.json
COPY requirements.txt /app/requirements.txt

# Make entrypoint.sh executable
RUN chmod +x /app/entrypoint.sh

# Install system dependencies and Python requirements
RUN apt update && apt install -y python3-venv python3-pip \
    && pip install --upgrade pip setuptools wheel \
    && pip install -r /app/requirements.txt

# Expose the necessary port
EXPOSE 5005

# Set the default command to run entrypoint.sh
CMD ["/app/entrypoint.sh"]
