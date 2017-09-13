#!/bin/bash
#
# deploy.sh <rds_endpoint> <rds_admin_db_password> <wordpress_db_password> <wordpress_admin_password>
#

###
# Create the wordpress site
#
echo "2. Create Wordpress Site"

cd wordpress
# Prompt asking if db should be deployed
read -p "Create new Wordpress DB? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
  ./deploy_db.sh $1 $2 $3 
fi
./deploy_site.sh $1 $2 $3 $4

cd ..

###
# create the container to use the wordpress site 
# 
echo "3. Create Container Images"

cd containers
./deploy.sh
cd ..

###
# Create the Infrastructure that uses the containers
#
echo "4. Terraform-ecs"

cd terraform-ecs
./deploy.sh
cd ..


###
# Create the dns entries 
#
echo "5. Terraform-dns"

cd terraform-dns
./deploy.sh
cd ..

echo "Complete."
