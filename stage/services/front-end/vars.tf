data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "lich1710-terraform-state"
    region = "ap-southeast-1"
    encrypt = true
    key = "stage/vpc/terraform.tfstate"
  }
}
