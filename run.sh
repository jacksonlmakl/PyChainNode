#!/bin/bash

# Read the port from node.json using jq
PORT=$(jq -r '.PORT' node.json)

# Build the Docker image
docker build -t pychainnode .

# Run the container with the dynamically extracted port
docker run -d -p $PORT:$PORT --name pychainnode_container pychainnode
