provider "aws" {
  region = "us-east-1"
}

variable "server_port" {
  description = "The port the server will listen on for HTTP requests"
  default = 8080
}

resource "aws_instance" "example_name" {
  ami	= "ami-40d28157"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
	#!/bin/bash
	echo "Hello, World" > index.html
	nohup busybox httpd -f -p ${var.server_port} &
	EOF

  tags {
	Name = "terraform-book-ch2-example"
	}
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance-ch2"

  ingress {
	from_port = "${var.server_port}"
	to_port	  = "${var.server_port}"
	protocol  = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
}

output "public_ip" {
  value = "${aws_instance.example_name.public_ip}"
}
