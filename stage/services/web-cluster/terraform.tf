terraform {
  backend "s3" {
    bucket = "lich1710-terraform-state"
    region = "ap-southeast-1"
    encrypt = true
    key = "stage/services/web-cluster/terraform.tfstate"
    //dynamodb_table = "terraform-state-lock-dynamo"
  }
}
