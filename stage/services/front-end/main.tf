provider "aws" {
  region = "ap-southeast-1"
}


module "frontend_1" {
  source = "../../../modules/frontend-app"

  #VPC we are using is staging VPC
  vpc_state_file_location = "stage/vpc/terraform.tfstate"
  server_port = 80
}
