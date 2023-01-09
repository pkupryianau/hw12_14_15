output "public_ip" {
    description = "Public ip addr Jenkins Server"
    value = aws_eip.jenkins_elastic_ip
  
}