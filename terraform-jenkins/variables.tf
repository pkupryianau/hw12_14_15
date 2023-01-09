variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr_block" {
  description = "vpc_subnet_ip"
  type = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr_block" {
  description = "public_ip_subnet"
  type = string
  default = "10.0.1.0/24"
}
variable "my_ip" {
  description = "my ip addr"
  type = string
  sensative = true
}
