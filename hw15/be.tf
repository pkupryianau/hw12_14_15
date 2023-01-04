# ДЗ лабораторная работа № 15
# Сервер BackEnd_1_2
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
resource "aws_instance" "BE1" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04 - AMI правильная версия или Amazon  Linux 2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.be_sg.id]
  provisioner "remote-exec" {  # Установка MariaDB1+WP
      inline = [
        "sudo apt update -y",
        "ssudo apt install mysql-server",
        "sudo mysql_secure_installation -y",
        "sudo cd /tmp",
        "sudo curl -LO https://wordpress.org/latest.tar.gz",
        "sudo tar xzvf latest.tar.gz",
        "sudo sudo cp -a /tmp/wordpress/. /var/www/wordpress",
        "sudo chown -R www-data:www-data /var/www/wordpress"
      ]
    }
    tags = {
    Name = "Backend_Server 1"
    Owner = "P.Kupryianau"
  }
}
resource "aws_instance" "BE2" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.be_sg.id]
  provisioner "remote-exec" {  # Установка MariaDB2+WP
      inline = [
        "sudo apt update -y",
        "ssudo apt install mysql-server",
        "sudo mysql_secure_installation -y",
        "sudo cd /tmp",
        "sudo curl -LO https://wordpress.org/latest.tar.gz",
        "sudo tar xzvf latest.tar.gz",
        "sudo sudo cp -a /tmp/wordpress/. /var/www/wordpress",
        "sudo chown -R www-data:www-data /var/www/wordpress"
      ]
    }
    tags = {
    Name = "Backend_Server 2"
    Owner = "P.Kupryianau"
  }
}

# Security Group
resource "aws_security_group" "be_sg" {
  name = "security_group_be"
  description = "SG for BE"
  

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
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5000
    protocol = "tcp"
    to_port = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {                            # запрет  внешних подключений!
    from_port       = 0 
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Backend_Server_Security_Group"
    Owner = "P.Kupryianau"
  }
}

# connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ec2-user"
#     private_key = file (".......pem") # место ключа
# }