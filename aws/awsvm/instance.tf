variable "aws_region" { default = "us-east-1" }
variable "key_path" { default = "/root/.ssh/cid.pem" }
variable "key_file" { default = "cid" }
variable "aws_access_key" { default = "AKIARE7Y5NPJ3VTBCCMY" }
variable "aws_secret_key" { default = "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" }
variable "instance_type" { default = "t2.large" }
#variable "aws_amis" { default = "ami-005bdb005fb00e791" }
variable "aws_amis" { default = "ami-07d0cf3af28718ef8"}


provider "aws"{
 access_key="${var.aws_access_key}"
 secret_key="${var.aws_secret_key}"
 region="${var.aws_region}"
}

resource "aws_instance" "rizVM" {
ami = "${var.aws_amis}"
key_name = "${var.key_file}"
instance_type = "${var.instance_type}"
vpc_security_group_ids = ["${aws_security_group.rizVM-sg.id}"]
root_block_device { delete_on_termination = true }
#tags { Name = "rizVM" }
associate_public_ip_address = true
     connection {
    type = "ssh"
    user = "ubuntu"
        host = "${aws_instance.rizVM.public_ip}"
    private_key = "${file(var.key_path)}"
     }
   provisioner "remote-exec" {
   inline = [
      "sudo apt-get update"
     ]
  }


}
output "ec2_global_ips" {
  value = ["${aws_instance.rizVM.public_ip}"]
}


resource "aws_security_group" "rizVM-sg" {
name = "rizVM-sg"
description = "Security group for testing"
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 0
to_port = 0
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 6443
to_port = 6443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
#tags {
#Name = "SG for Instance(s)"
#  }
}
