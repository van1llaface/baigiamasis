#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo yum install git -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on

cd /home/ec2-user
git clone https://github.com/van1llaface/baigiamasis.git
cd baigiamasis

sudo docker build -t baigiamasis-app .
sudo docker run -d -p 80:3000 baigiamasis-app
