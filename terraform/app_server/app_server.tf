resource "aws_instance" "app_server" {
  ami           = "ami-0f65a9eac3c203b54"
  instance_type = "t3.micro"
  vpc_security_group_ids = var.sg_from_module
  subnet_id = var.subnet_from_module

  tags = {
    Name = "AppServerInstance"
  }
}