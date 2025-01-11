#!/bin/bash

# Use this to stop everything, and remove the backing images, so next time we go up, they'll pull latest

# Stop all running Docker containers
echo "Stopping all running Docker containers..."
docker stop $(docker ps -q)

# Remove all Docker containers
echo "Removing all Docker containers..."
docker rm $(docker ps -aq)

# Remove all Docker images
echo "Removing all Docker images..."
docker rmi -f $(docker images -q)

echo "All Docker containers have been stopped and removed, and all Docker images have been deleted."
