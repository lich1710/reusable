provider "aws" {
  region = "ap-southeast-1"
}

output "subnet" {
  value = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
}
