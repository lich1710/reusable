
terraform {
  backend "s3" {
    # Provide your own bucket name here
    bucket = "unique-s3-bucket"
    region = "ap-southeast-1"
    encrypt = true
    key = "stage/vpc/terraform.tfstate"
    //dynamodb_table = "terraform-state-lock-dynamo"
  }
}
