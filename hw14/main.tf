# ДЗ лабораторная работа № 14
terraform {
  required_version = ">= 0.13.1"
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
  }
}
provider "aws" {
   region = "us-east-1"  # !!!  Access_key + secret_key
}
resource "aws_instance" "my_test_ec2" {
  ami = "ami-0c55b159cbfafe1f0"  #ubuntu18.04
  instance_type = "t2.micro"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, prkpo" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  output "public_ip" {
     description = "Public IP"
     value = aws_instance.my_test_ec2.public_ip
    }
  output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "The domain  name of the LB"
  }
  tags = {
    Name = "terraform-example"
    Owner = "P.Kupryianau"
  }
}
# create EBS volume
resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-east-1"
  size = 1  
  tags = {
    "name" = "data-volume"
  }
}
resource "aws_volume_attachment" "ec2_ebs_attach" {
  device_name = "/dev/sdf" 
  volume_id = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.my_test_ec2.id
}
# create SecurityGroup
resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg_example"
  ingress  {
    cidr_blocks = ["0.0.0.0/0" ]
    description = "ingress_policy_1"
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  } 
  egress {
    description = "egress_policy_1"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "security-group-example"
    Owner = "P.Kupryianau"
  }
}