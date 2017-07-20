provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "informed_parents_s3" {
  bucket = "copperleafsoftwaresolutions.informed-parents.org"
  acl    = "private"
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "copperleafsoftwaresolutions.informed-parents.org"
    region = "us-west-2"
    key    = "terraform.tfstate"
  }
}

data "terraform_remote_state" "informed_parents_s3_state" {
  backend  = "s3"
  config {
    bucket = "${aws_s3_bucket.informed_parents_s3.bucket}"
    region = "us-west-2"
    key    = "terraform.tfstate"
  }
}