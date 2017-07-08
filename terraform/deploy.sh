#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

terraform apply -var 'db_password=$1'