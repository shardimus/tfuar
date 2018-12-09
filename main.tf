provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sh1" {
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  subnet_id = "subnet-1dabf640"
  tags {
      Name = "sh1"
  }
  
}

