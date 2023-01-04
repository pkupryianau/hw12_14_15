# https://blog.gruntwork.io/a-crash-course-on-terraform-5add0d9ef9b4
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the server"
}
output "instance_id" {
  value       = aws_instance.example.id
  description = "The ID of the server"
}
