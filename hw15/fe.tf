# ДЗ лабораторная работа № 15
# Сервер FrontEnd_1_2
terraform {
  required_version = ">= 0.13.1"
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0"
    }
  }
}
provider "aws" {
   region = "us-east-1"  # !!!  Access_key + secret_key
}
resource "aws_instance" "FE1" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04 - AMI правильная версия или Amazon  Linux 2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.fe_sg.id]
  provisioner "remote-exec" {  # Установка Apache
      inline = [
        "sudo apt update -y",
        "sudo apt install apache2",
        #"sudo ufw allow 'Apache Full'",
        "sudo apt install php libapache2-mod-php php-mysql",
        "sudo systemctl start apache2",
        "sudo systemctl enable apache2",
        
      ]
    }
    tags = {
    Name = "Frontend_Server 1"
    Owner = "P.Kupryianau"
  }
}
resource "aws_instance" "FE2" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.fe_sg.id]
  provisioner "remote-exec" {  # Установка Apache
      inline = [
        "sudo apt update -y",
        "sudo apt install apache2",
        #"sudo ufw allow 'Apache Full'",
        "sudo apt install php libapache2-mod-php php-mysql",
        "sudo systemctl start apache2",
        "sudo systemctl enable apache2"
      ]
    }
    tags = {
    Name = "Frontend_Server 2"
    Owner = "P.Kupryianau"
  }
}

# Security Group
resource "aws_security_group" "fe_sg" {
  name = "security_group_fe"
  description = "SG for FE"
  

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["/32"] # VPN Network
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {                                      # запрет  внешних подключений!
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Frontend_Server_Security_Group"
    Owner = "P.Kupryianau"
  }
}

# connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ec2-user"
#     private_key = file (".......pem") # место ключа
# }