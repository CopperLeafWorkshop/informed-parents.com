#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

###
# Run Terraform
#

terraform plan -var 'db_password=$1'
read -p "Apply? (y/n) : " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply -var 'db_password=$1'
fi
