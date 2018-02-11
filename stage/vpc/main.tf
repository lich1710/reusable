provider "aws" {
  region = "ap-southeast-1"
}


resource "aws_vpc" "stage" {
  cidr_block = "10.0.0.0/18"

  tags {
    Name = "Stage VPC"
  }
}

resource "aws_subnet" "stage-1a" {
    vpc_id = "${aws_vpc.stage.id}"
    availability_zone = "ap-southeast-1a"
    cidr_block = "10.0.1.0/24"
    tags {
      Name = "Stage-1a"
    }
}

resource "aws_subnet" "stage-1b" {
    vpc_id = "${aws_vpc.stage.id}"
    availability_zone = "ap-southeast-1b"
    cidr_block = "10.0.2.0/24"

    tags {
      Name = "Stage-1b"
    }
}

resource "aws_subnet" "stage-1c" {
    vpc_id = "${aws_vpc.stage.id}"
    availability_zone = "ap-southeast-1c"
    cidr_block = "10.0.3.0/24"

    tags {
      Name = "Stage-1c"
    }

}
