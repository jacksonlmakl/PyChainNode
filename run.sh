#!/bin/bash

# Function to check and install Docker if it's not installed
install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        echo "Docker is not installed. Installing Docker..."
        # Install Docker based on the OS
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update
            sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update
            sudo apt install -y docker-ce
            sudo systemctl start docker
            sudo systemctl enable docker
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS requires Docker Desktop installation
            echo "Please install Docker Desktop manually from https://www.docker.com/products/docker-desktop."
            exit 1
        else
            echo "Unsupported OS. Please install Docker manually."
            exit 1
        fi
    else
        echo "Docker is already installed."
    fi
}

# Function to check and install jq if it's not installed
install_jq() {
    if ! [ -x "$(command -v jq)" ]; then
        echo "jq is not installed. Installing jq..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update
            sudo apt install -y jq
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install jq
        else
            echo "Unsupported OS. Please install jq manually."
            exit 1
        fi
    else
        echo "jq is already installed."
    fi
}

# Ensure Docker is running on macOS
start_docker_mac() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! pgrep -x "Docker" > /dev/null; then
            echo "Starting Docker Desktop..."
            open --background -a Docker
            while ! docker system info > /dev/null 2>&1; do
                echo "Waiting for Docker Desktop to start..."
                sleep 5
            done
        fi
    fi
}

# Step 1: Install Docker and jq if needed
install_docker
install_jq

# Ensure Docker is running on macOS
start_docker_mac

# Step 2: Read the port from node.json using jq
PORT=$(jq -r '.PORT' node.json)

# Step 3: Check if the port was correctly extracted
if [ -z "$PORT" ]; then
  echo "Error: Port is empty or could not be read from node.json"
  exit 1
fi
echo "Extracted PORT: $PORT"

# Step 4: Build the Docker image
docker build -t pychainnode .

# Step 5: Run the Docker container with the dynamically extracted port
docker run -d -p $PORT:$PORT --name pychainnode_container pychainnode
