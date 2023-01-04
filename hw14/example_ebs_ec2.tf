#selecting our region for instance
provider "aws" {
  region = "    "
}

#creating security group
resource "aws_security_group" "ssh-http" {
  name        = "ssh-http"
  description = "allow ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#creating aws instance
resource "aws_instance" "ec2" {
  ami               = "  " # ami iso
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  security_groups   = ["${aws_security_group.ssh-http.name}"]
  key_name = ""
  user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1>Sample Webserver " 
  EOF


  tags = {
        Name = "webserver"
  }

}

#creating and attaching ebs volume

resource "aws_ebs_volume" "data-vol" {
 availability_zone = "  "
 size = 1
 tags = {
        Name = "data-volume"
 }

}
#
resource "aws_volume_attachment" "ec2-ebs-vol" {
 device_name = "/dev/sdc"
 volume_id = "${aws_ebs_volume.data-vol.id}"
 instance_id = "${aws_instance.ec2.id}"
}