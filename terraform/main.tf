provider "aws" {
  region = "eu-north-1"
}
 
resource "aws_instance" "example" {
  ami           = "ami-0274f4b62b6ae3bd5" # Amazon Linux 2 AMI (example)
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
 
  user_data = file("user_data.sh")
 
  tags = {
    Name = "Baigiamasis-EC2-TODO"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow inbound HTTP, HTTPS, and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom port (e.g., 3000)"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

data "aws_vpc" "default" {
  default = true
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
