#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Update the system
sudo dnf update -y

# Install Docker and Git
sudo dnf install -y docker git

# Start Docker service
sudo systemctl start docker

# Add ec2-user to the docker group
sudo usermod -aG docker ec2-user

# Enable Docker to start on boot
sudo systemctl enable docker

# Install Docker Compose (v2+ compatible)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ensure ec2-user owns the home directory
sudo chown -R ec2-user:ec2-user /home/ec2-user

# Clone your repository
cd /home/ec2-user
git clone https://github.com/van1llaface/baigiamasis.git
cd baigiamasis

# Start your Docker app as ec2-user
sudo -u ec2-user /usr/local/bin/docker-compose up -d
