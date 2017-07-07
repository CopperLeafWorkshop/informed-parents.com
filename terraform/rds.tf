provider "aws" {
  region                   = "us-west-2"
}

resource "aws_db_instance" "informed_parents_db" {  
  allocated_storage        = 10 # gigabytes
  backup_retention_period  = 7   # in days
  engine                   = "mariadb"
  identifier               = "informed-parents-rds"
  instance_class           = "db.t2.small"
  multi_az                 = false
  name                     = "informed_parents_dev_env_db"
  password                 = "${var.db_password}"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  username                 = "informed_parents"
  vpc_security_group_ids   = ["${aws_security_group.informed_parents_sg.id}"]
}


resource "aws_security_group" "informed_parents_sg" {  
  name = "informed_parents_sg"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "informed_parents_s3" {
  bucket = "copperleafsoftwaresolutions.informed-parents.org"
  acl = "private"
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
  backend = "s3"
  config {
    bucket = "${aws_s3_bucket.informed_parents_s3.bucket}"
    region = "us-west-2"
    key = "terraform.tfstate"
  }
}