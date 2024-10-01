#!/bin/bash

# Build the Docker image
docker build -t pychainnode .

# Run the container with environment variables and parameters
docker run -d -p 5005:5005 --name pychainnode_container pychainnode
