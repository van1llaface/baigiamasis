provider "aws" {
  region = "eu-north-1"
}

# Create a security group to allow all traffic (insecure, for dev/testing)
# resource "aws_security_group" "allow_web" {
#   name        = "allow_all"
#   description = "Allow all inbound traffic"
#   vpc_id      = "vpc-03d1810d15c24c49b"

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# Launch EC2 instance
resource "aws_instance" "example" {
  ami                    = "ami-02ec57994fa0fae21" # Replace with valid AMI
  instance_type          = "t3.micro"
  # vpc_security_group_ids = [aws_security_group.allow_web.id]
  vpc_security_group_ids = ["sg-092e30ec949deb682"]

  key_name      = "baigiamasis-pem"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "baigiamasis_ec2"
  }
}

