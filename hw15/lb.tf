# ДЗ лабораторная работа № 15
# Сервер LoadBalancer
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
resource "aws_instance" "LoadBalancer" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04 - AMI правильная версия или Amazon  Linux 2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.lbs_sg.id]
  provisioner "remote-exec" {  # Установка NGINX 
      inline = [
        #"sudo amazon-linux-extras install epel -y",
        "sudo apt update -y",
        "sudo apt install nginx",
        #"sudo ufw allow 'NGINX Full', 'OpenSSH' ",
        "sudo systemctl start nginx",
        "sudo systemctl enable nginx"
      ]
    }
    tags = {
    Name = "LoadBalancer_Server"
    Owner = "P.Kupryianau"
  }
}
# Security Group
resource "aws_security_group" "lbs_sg" {
  name = "security_group_lbs"
  description = "SG for LBS"
  

  // To Allow SSH Transport from IP only VPN
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["/32"] # VPN Network
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {                            
    from_port       = 0 
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "LoadBalancer_Server_Security_Group"
    Owner = "P.Kupryianau"
  }
}

# connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ec2-user"
#     private_key = file (".......pem") # место ключа
# }