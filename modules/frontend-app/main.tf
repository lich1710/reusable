provider "aws" {
  region = "ap-southeast-1"
}



################################################
# CREATE WEB INSTANCES
################################################

resource "aws_instance" "web_instance" {
  count = 3

  ami = "ami-b7f388cb"
  instance_type = "t2.micro"
  #associate_public_ip_address = true
  #key_name = "newKey"

  # Assign subnet and security group for the instance
  subnet_id = "${data.terraform_remote_state.vpc.public_subnet_ids[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.instances.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "example - ${count.index}"
  }
}

# Secuity group for instances
resource "aws_security_group" "instances" {
    name = "http_rules"
    vpc_id = "${data.terraform_remote_state.vpc.public_vpc_id[0]}"
}

resource "aws_security_group_rule" "http_rules" {
    type = "ingress"
    security_group_id = "${aws_security_group.instances.id}"

    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}



#===========================================================
#Deploy a load balancer & its own security group
#===========================================================


resource "aws_elb" "elb" {
    name = "example-webcluster-elb"
    security_groups = ["${aws_security_group.elb.id}"]
    subnets = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]

    listener {
      instance_port = "${var.server_port}"
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:${var.server_port}/"
      interval = 30
    }

    instances                   = ["${aws_instance.web_instance.*.id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400
}

#Deploy the elb security group
resource "aws_security_group" "elb" {
    name = "example-elb"
    vpc_id = "${data.terraform_remote_state.vpc.public_vpc_id[0]}"
}

resource "aws_security_group_rule" "elb_rules" {
    type = "ingress"
    security_group_id = "${aws_security_group.elb.id}"

    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "health_check" {
    type = "egress"
    security_group_id = "${aws_security_group.elb.id}"

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
