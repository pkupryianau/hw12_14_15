variable "vpc_id" {
  description = "ID for VPC"
  type = string
}

variable "my_ip" {
  description = "My IP "
  type = string
}
resource "aws_security_group" "tutorial_jenkins_sg" {
  name = "tutorial_jenkins_sg"
  description = "SG for Jenkins Server"
  vpc_id = var.vpc_id
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow through 8080"
    from_port = "8080"
    protocol = "tcp"
    to_port = "8080"
  } 
   ingress  {
    cidr_blocks = [ "${var.my_ip}/32" ]
    description = "allow from  ssh"
    from_port = "22"  # change default port for SSH!!!!!!
    protocol = "tcp"
    to_port = "22"
  } 
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all outgoing traffic"
    from_port = "0"
    protocol = "tcp"
    to_port = "0"
  } 
  tags = {
    "Name" = "tuorial_jenkins_sg"
  }
}
 