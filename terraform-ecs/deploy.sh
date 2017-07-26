#!/bin/bash
#
# deploy.sh 
#

###
# Run Terraform
#

terraform plan 
read -p "Apply? (y/n) : " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply 
fi
terraform graph | dot -Tpng > graph-ecs.png
