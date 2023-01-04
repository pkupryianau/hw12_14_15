resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-east-1"
  size = 10  
}
resource "aws_volume_attachment" "ec2_ebs_attach" {
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.my_test_ec2.id
}
