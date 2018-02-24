provider "aws" {
  region = "ap-southeast-1"
}



################################################
# CREATE SINGLE WEB INSTANCE
################################################

resource "aws_instance" "web_instance" {
  count = 3

  ami = "ami-b7f388cb"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "newKey"

  # Assign subnet and security group for the instance
  subnet_id = "${data.terraform_remote_state.vpc.public_subnet_ids[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.http_rules.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "example - ${count.index}"
  }
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
