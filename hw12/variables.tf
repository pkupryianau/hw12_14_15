variable "subnet_id_1" {
  type = string
  default = "subnet-your_first_subnet_id"
 }
 
 variable "subnet_id_2" {
  type = string
  default = "subnet-your_second_subnet_id"
 }

#  resource "aws_subnet" "myprivsubnet" {
#   assign_ipv6_address_on_creation = false
#   availability_zone               = "eu-east-1a"
#   cidr_block                      = "10.1.4.0/24"
#   map_public_ip_on_launch         = false
#   tags = {
#     "Name" = "Private subnet 10.1"
#   }
#   vpc_id = aws_vpc.vpc-10-1.id

#   timeouts {}
# }

# resource "aws_subnet" "mypubsubnet" {
#   assign_ipv6_address_on_creation = false
#   availability_zone               = "eu-east-1a"
#   cidr_block                      = "10.1.1.0/24"
#   map_public_ip_on_launch         = false
#   tags = {
#     "Name" = "Public subnet 10.1"
#   }
#   vpc_id = aws_vpc.vpc-10-1.id

#   timeouts {}
# }


