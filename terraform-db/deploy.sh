#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

###
# Run Terraform
#
echo "0 $0"
echo "1 $1"
echo "2 $2"
terraform plan -var 'db_password=$1'
read -p "Apply? (y/n) : " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply -var 'db_password=$1'
fi
terraform graph | dot -Tpng > graph-db.png
