#!/bin/bash

# Update package list
sudo apt update

# Install Python (adjust the version if necessary)
sudo apt install -y python3 python3-venv python3-pip

# Check if Python installed successfully
if command -v python3 &>/dev/null; then
    echo "Python installed successfully."
else
    echo "Python installation failed."
    exit 1
fi

# Create a virtual environment in the current directory
python3 -m venv env

# Activate the virtual environment
source env/bin/activate

# Confirm the environment is activated
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "Virtual environment 'env' created and activated successfully."
else
    echo "Failed to create or activate virtual environment."
    exit 1
fi

# Install essential packages
pip install --upgrade pip setuptools wheel
pip install ChainEngine
echo "Environment setup complete."

echo "Launching Node."
python3 node.py

