output "public_subnet_id" {
  description = "ID public subnet"
  value = aws_subnet.tutorial_public_subnet.id
}
output "vpc_id" {
  description = "ID of VPC"
  value = aws_vpc.local_network_vpc.id
}