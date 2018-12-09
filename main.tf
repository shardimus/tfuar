provider "aws" {
  region = "us-east-1"
}

 # resource "aws_instance" "sh1" {
#   ami = "ami-0ac019f4fcb7cb7e6"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = ["${aws_security_group.sh1-ssh.id}"]
#   subnet_id = "subnet-dfb3ee82"
#   associate_public_ip_address = "True"
#   key_name = "scotth"
#   tags {
#       Name = "sh1"
#   }
#   user_data = <<-EOF
#     #!/bin/bash
#     apt-get update
#     apt-get install -y apache2
#     service apache2 start
#     EOF
# }

data "aws_availability_zones" "all" {}

resource  "aws_launch_configuration" "sh1-lc" {
  image_id = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.sh1-ssh.id}"]
  key_name = "scotth"
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    service apache2 start
    EOF
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sh1-ssh" {
  name = "test-terrafrom-instance"
  vpc_id = "vpc-06b56c7d"
  ingress {
    from_port = "${var.web_port}"
    to_port = "${var.web_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "sh-asg" {
  launch_configuration = "${aws_launch_configuration.sh1-lc.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  # vpc_zone_identifier = ["subnet-dfb3ee82", "subnet-dfb3ee82"]
  vpc_zone_identifier = ["${var.sub1}", "${var.sub2}"]

  
  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform-sh-asg"
    propagate_at_launch = true
  }
}
