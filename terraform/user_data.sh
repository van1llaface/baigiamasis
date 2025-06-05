#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Update the system
sudo yum update -y

# Install Docker and Git
sudo yum install -y docker git

# Start Docker service
sudo systemctl start docker

# Add ec2-user to the docker group
sudo usermod -aG docker ec2-user

# Enable Docker to start on boot
sudo systemctl enable docker

# Install Docker Compose (v2+ compatible)
sudo yum install docker-compose-plugin -y
# sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sleep 10

# Clone your repository
sudo -u ec2-user  git clone https://github.com/van1llaface/baigiamasis.git
sudo /usr/local/bin/docker-compose -f /home/ec2-user/baigiamasis/compose.yml up -d
