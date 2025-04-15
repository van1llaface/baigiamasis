#!/bin/bash
# Update system and install Docker and Git
yum update -y
amazon-linux-extras install docker -y
yum install git -y
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

# Clone your GitHub repo
cd /home/ec2-user
git clone https://github.com/van1llaface/baigiamasis.git
cd baigiamasis

# Build and run your Docker app
docker build -t baigiamasis-app .
docker run -d -p 80:3000 baigiamasis-app
