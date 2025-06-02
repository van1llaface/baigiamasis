provider "aws" {
  region = "eu-north-1"
}

# Launch EC2 instance
resource "aws_instance" "example" {
  ami                    = "ami-02ec57994fa0fae21"  #"ami-00f34bf9aeacdf007" Replace with valid AMI
  instance_type          = "t3.micro"
  # vpc_security_group_ids = [aws_security_group.allow_web.id]
  vpc_security_group_ids = ["sg-092e30ec949deb682"]

  key_name      = "baigiamasis-pem"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "baigiamasis_ec2"
  }
}


variable "my_ip" {
  default = "88.118.188.189/32"
}

resource "aws_security_group" "only_my_ip" {
  name        = "only-my-ip-access"
  description = "Allow access only from my IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTPS from my IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "OnlyMyIPSecurityGroup"
  }
}
