provider "aws" {
  region = "eu-north-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "BaigiasmasisVPC"
  }
}

# Create a public subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"
}

# Create a security group to allow all traffic (insecure, for dev/testing)
resource "aws_security_group" "allow_web" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instance
resource "aws_instance" "example" {
  ami                    = "ami-0274f4b62b6ae3bd5" # Replace with valid AMI
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  key_name      = "baigiamasis-pem"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "baigiamasis_ec2"
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
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.route_table.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}


# resource "aws_db_instance" "mydb" {
#   allocated_storage  = 20
#   storage_type       = "gp2"
#   engine             = "mysql"
#   engine_version     = "8.0"
#   instance_class     = "db.t3.micro"
#   db_name            = "baigiasmasis_db"
#   username           = var.db_username
#   password           = var.db_password
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot = true
#   vpc_security_group_ids = [aws_security_group.sg.id]
# }

# output "db_connect_string" {
#   description = "MySQL database connection string"
#   value       = "Server=${aws_db_instance.mydb.address}; Database=mydb; Uid=${var.db_username}; Pwd=${var.db_password}"
#   sensitive   = true
# }

# variable "db_username" {
#   description = "Database Username"
#   default     = "adminas"
#   type        = string
# }

# variable "db_password" {
#   description = "Database Password"
#   default     = "AdminAdmin1234."
#   type        = string
#   sensitive   = true
# }
