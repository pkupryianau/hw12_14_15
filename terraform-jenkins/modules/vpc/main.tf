variable "vpc_cidr_block" {
  description = "vpc_subnet_ip"
}
resource "aws_vpc" "local_network_vpc" {
  cidr_block = var.vpc_cidr_block.id
  enable_dns_hostnames = true
  tags = {
    Name = "local_network_vpc"
  }  
}
resource "aws_internet_gateway" "tutorial_igw" {
  vpc_id = aws_vpc.local_network_vpc.id
  tags =  {
    Name = "tutorial_igw"
  }
}
resource "aws_route_table" "tutorial_public_rt" {
  vpc_id = aws_vpc.local_network_vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.tutorial_igw.id"
  } 
}
variable "public_subnet_cidr_block" {
  description = "cidr block of public subnet"
}
data "aws_availability_zone" "available" {
  state = "available"
}
resource "aws_subnet" "tutorial_public_subnet" {
  vpc_id = aws_vpc.local_network_vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = data.aws_availability_zone.available.names[0]
  tags = {
    "Name" = "tutorial_public_subnet"
  }
}
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.tutorial_public_rt.id
  subnet_id = aws_subnet.tutorial_public_subnet.id
}