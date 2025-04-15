#!/bin/bash
# Update system and install Docker and Git
yum update -y
yum install -y docker
yum install git -y
yum install -y python3-pip

# Install Docker Compose
pip3 install docker-compose

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group (to avoid using sudo for Docker commands)
usermod -aG docker ec2-user

# Apply the group change immediately (no need to log out and log back in)
newgrp docker

# Clone your GitHub repo
cd /home/ec2-user
git clone https://github.com/van1llaface/baigiamasis.git
cd baigiamasis

# Create a docker-compose.yml file (if not already in the repo)
cat > docker-compose.yml <<EOF
version: '3'
services:
  app:
    build: .
    ports:
      - "80:3000"
    networks:
      - app_network
networks:
  app_network:
    driver: bridge
EOF

# Build and run the containers with Docker Compose
docker-compose up -d

# Check if the container is running
docker ps
