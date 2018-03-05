provider "aws" {
  region = "ap-southeast-1"
}

#===========================================================
#Create AWS Launch Configuration for new AWS AutoScaling Group
#===========================================================

resource "aws_launch_configuration" "cluster" {
  image_id = "ami-b7f388cb"
  instance_type = "${var.ec2_instance_type}"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  #Tell terraform to always create new instance before destroy
  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for the ASG
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-webinstance"
  # Because the Launch Configuration using this Security Group, and it has
  # lifecycle rules, all the dependency also need lifecycle rules
  vpc_id = "${data.terraform_remote_state.vpc.public_vpc_id[0]}"

  lifecycle {
    create_before_destroy = true
  }
}
# Rules for above security group
resource "aws_security_group_rule" "allow_http" {
    type = "ingress"
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.instance.id}"
}

#===========================================================
#Create AWS AutoScaling Group
#===========================================================

resource "aws_autoscaling_group" "cluster" {
    launch_configuration = "${aws_launch_configuration.cluster.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    vpc_zone_identifier = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]


    min_size = "${var.min_size}"
    max_size = "${var.max_size}"

    load_balancers = ["${aws_elb.elb.name}"]
    health_check_type = "ELB"

    tag {
      key = "Name"
      value = "${var.cluster_name}-asg"
      propagate_at_launch = true
    }
}

#===========================================================
#Deploy a load balancer & its own security group
#===========================================================


resource "aws_elb" "elb" {
    name = "${var.cluster_name}-asg-elb"
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
}

#Deploy the elb security group
resource "aws_security_group" "elb" {
    name = "${var.cluster_name}-elb"
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
