#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum update -y
sudo yum install docker -y
sudo yum install git -y
sudo service docker start sleep 10
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on


sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

cd /home/ec2-user
git clone https://github.com/van1llaface/baigiamasis.git
cd baigiamasis

docker-compose up -d
