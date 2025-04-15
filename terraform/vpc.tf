provider "aws" {
  region = "eu-north-1"  # Change to your preferred AWS region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # Modify the CIDR block if needed
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"  # Modify to your desired AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "MainSubnet"
  }
}

# Create an Internet Gateway for public access
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# Create a route table and associate it with the subnet
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "MainRouteTable"
  }
}

resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}
