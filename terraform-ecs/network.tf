resource "aws_default_vpc" "default_vpc" {
    tags {
        Name = "Default VPC"
    }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"

    tags {
        Name = "Default subnet for us-west-2a"
    }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"

    tags {
        Name = "Default subnet for us-west-2b"
    }
}
