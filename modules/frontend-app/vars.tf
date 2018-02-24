variable "vpc_state_file_location" {
  description = "Location of the state file of the VPC"
}


# Read VPC state to get VPC info
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "lich1710-terraform-state"
    region = "ap-southeast-1"
    encrypt = true
    key = "${var.vpc_state_file_location}"
    #key = "stage/vpc/terraform.tfstate"
  }
}

data "aws_availability_zones" "all" {}

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
