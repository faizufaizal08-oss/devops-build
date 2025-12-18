#!/bin/bash

# Exit on any error
set -e

# Image name
IMAGE_NAME="react-static-prod"

# Build Docker image
echo "Building Docker image: $IMAGE_NAME"
docker build --no-cache -t $IMAGE_NAME .

echo "Docker image $IMAGE_NAME built successfully."
