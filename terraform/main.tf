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


