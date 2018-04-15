provider "aws" {
  region     = "ap-southeast-1"
}


resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.unique_S3_bucket_name}"

    versioning {
      enabled = true
    }
}
