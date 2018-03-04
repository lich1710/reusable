provider "aws" {
  region = "ap-southeast-1"
}

module "web_cluster_1" {
  source = "../../../modules/web-cluster"

  #INPUT FOR MODULE'S VARIABLE

  #VPC we are using is staging VPC. This location is stored on S3
  vpc_state_file_location = "stage/vpc/terraform.tfstate"
  #Port for webserver is 80
  server_port = 80
  cluster_name = "Staging"
  min_size = 2
  max_size = 2

}
