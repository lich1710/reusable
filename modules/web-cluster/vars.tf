variable "vpc_state_file_location" {
  description = "Location of the state file of the VPC"
}


# Read VPC state to get VPC info
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "unique-s3-bucket"
    region = "ap-southeast-1"
    encrypt = true
    key = "${var.vpc_state_file_location}"
    #key = "stage/vpc/terraform.tfstate"
  }
}

data "aws_availability_zones" "all" {}


############################################################
# CLUSTER INPUT
############################################################

variable "min_size" {
  default = 1
  description = "Min number of EC2 instances"
}
variable "max_size" {
  default = 1
  description = "Max number of EC2 instances"
}

variable "cluster_name" {
  description = "Name of the cluster"
}


############################################################
# WEB INSTANCE INPUT
############################################################

variable "ec2_instance_type" {
  default = "t2.micro"
  description = "EC2 Instance Type"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-script.sh")}"

  vars {
    http_port = "${var.server_port}"
  }
}

# Define web server port
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}
