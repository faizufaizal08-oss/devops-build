#!/bin/bash

# Exit on any error
set -e

# Image and container names
IMAGE_NAME="react-static-prod"
CONTAINER_NAME="react-static-prod"

# Stop and remove any existing container
echo "Stopping and removing existing container (if any)..."
docker rm -f $CONTAINER_NAME || true

# Run new container on port 80
echo "Deploying container $CONTAINER_NAME from image $IMAGE_NAME..."
docker run -d -p 80:80 --name $CONTAINER_NAME $IMAGE_NAME

echo "Container $CONTAINER_NAME is running on port 80."
