provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "dns.informed-parents.org.tfstate"
  }
}

data "terraform_remote_state" "informed_parents_s3_state" {
  backend  = "s3"
  config {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "dns.informed-parents.org.tfstate"
  }
}

data "terraform_remote_state" "informed_parents_ecs_state" {
  backend  = "s3"
  config {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "ecs.informed-parents.org.tfstate"
  }
}
