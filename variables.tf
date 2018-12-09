variable "sub1" {
    description = "subnet 1"
    default = "subnet-dfb3ee82"
}

variable "sub2" {
    description = "subnet 1"
    default = "subnet-030d0a67"
}

variable "web_port" {
    description = "tcp port web server will listen on"
    default = 80
}

variable "ssh_port" {
  description = "tcp port for ssh"
  default = 22
}
