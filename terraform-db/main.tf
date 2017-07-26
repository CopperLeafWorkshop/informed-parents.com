provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "db.informed-parents.org.tfstate"
  }
}

data "terraform_remote_state" "informed_parents_s3_state" {
  backend  = "s3"
  config {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "db.informed-parents.org.tfstate"
  }
}

data "terraform_remote_state" "copperleaf_aws_shared_resources" {
  backend  = "s3"
  config {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "copperleaf-aws-shared-resources.tfstate"
  }
}
