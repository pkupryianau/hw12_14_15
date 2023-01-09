variable "security_group" {
    description = "SG for jenkins Server"
}
variable "public_subnet" {
    description = "Public subnet for jenkins Server"
}
resource "aws_instance" "jenkins_server" {
  ami = ""
  instance_type = "t2.medium"
  subnet_id = var.public_subnet
  vpc_security_group_ids = [ var.security_group ]
  key_name = aws_key_pair.tutorial_kp.key_name
  user_data = "${file("${path.module}/install_jenkins.sh")}"
   tags ={
    name = "Jenkins Server"
  } 
}
resource "aws_key_pair" "tutorisl_kp" {
    key_name = "tutorisl_kp"
    public_key = file("${path.module}/tutorial_kp.pub")
}
resource "aws_eip" "jenkins_elastic_ip" {
    instance = aws_instance.jenkins_server.id
    vpc = true
    tags = {
        Name = "jenkins_elastic_ip"
    }
}