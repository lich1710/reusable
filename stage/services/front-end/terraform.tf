terraform {
  backend "s3" {
    bucket = "unique-s3-bucket"
    region = "ap-southeast-1"
    encrypt = true
    key = "stage/services/front-end/terraform.tfstate"
    //dynamodb_table = "terraform-state-lock-dynamo"
  }
}
