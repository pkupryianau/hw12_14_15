# ДЗ лабораторная работа № 15
# Сервер Monitoring
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
   region = "us-east-1"  # !!!  Access_key + secret_key,  правльно через aws cli in  env!
}
resource "aws_instance" "MonitorServer" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04 - AMI правильная версия или Amazon  Linux 2
  instance_type = "t2.micro"  #   t2.medium
  vpc_security_group_ids = [aws_security_group.ms_sg.id]
  provisioner "remote-exec" {  # Установка Zabbix  https://itlocate.ru/blog/zabbix/ustanovka-i-bazovaya-nastrojka-zabbix-5.0-na-ubuntu-18.04.html
      inline = [
        "sudo wget -O https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+bionic_all.deb",
        "sudo dpkg -i zabbix-release_5.0-1+bionic_all.deb",
        "sudo apt update -y",
        "sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf",
        "sudo apt install zabbix-agent",
        "sudo systemctl restart zabbix-server zabbix-agent apache2",
        "sudo ystemctl enable zabbix-server zabbix-agent apache2"
      ]
    }
    tags = {
    Name = "LoadBalancer_Server"
    Owner = "P.Kupryianau"
  }
}
# Security Group
resource "aws_security_group" "ms_sg" {
  name = "security_group_monitoring_server"
  description = "SG for MS"
  

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
    from_port = 6000
    protocol = "tcp"
    to_port = 6000
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {                            
    from_port       = 0 
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Monitoring_Server_Security_Group"
    Owner = "P.Kupryianau"
  }
}

# connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ec2-user"
#     private_key = file (".......pem") # место ключа
# }