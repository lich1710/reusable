provider "aws" {
  region = "ap-southeast-1"
}


resource "aws_vpc" "stage" {
  cidr_block = "10.0.0.0/18"

  tags {
    Name = "Stage VPC"
  }
}

###################################################################
# Create internetGW
# Create route Table for the IGW
# Make new route table become main route Table
###################################################################

resource "aws_route_table" "internetGW" {
    vpc_id = "${aws_vpc.stage.id}"

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.stage_gateway.id}"
    }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.stage.id}"
  route_table_id = "${aws_route_table.internetGW.id}"
}

resource "aws_internet_gateway" "stage_gateway" {
    vpc_id = "${aws_vpc.stage.id}"

    tags {
      Name = "Stage_GW"
    }
}

###################################################################
# Create 3 Subnet
###################################################################

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
