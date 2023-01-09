output "sg_id" {
  description = "ID jenkins server security group"
  value = aws_security_group.tutorial_jenkins_sg.id
}