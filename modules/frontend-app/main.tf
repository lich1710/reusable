provider "aws" {
  region = "ap-southeast-1"
}



################################################
# CREATE SINGLE WEB INSTANCE
################################################

resource "aws_instance" "web_instance" {
  ami = "ami-b7f388cb"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  # Assign subnet and security group for the instance
  subnet_id = "${data.terraform_remote_state.vpc.public_subnet_ids[0]}"
  vpc_security_group_ids = ["${aws_security_group.http_rules.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello , World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

################################################
# CREATE SECURITY GROUP
################################################

resource "aws_security_group" "http_rules" {
  name = "http_rules"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${data.terraform_remote_state.vpc.public_vpc_id[0]}"
}
