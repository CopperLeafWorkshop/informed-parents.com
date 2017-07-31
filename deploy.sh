#!/bin/bash
#
# deploy.sh <rds_admin_db_password> <wordpress_db_password> <wordpress_admin_password>
#

###
# Create the database 
#
cd terraform-db
./deploy.sh $1
db_address="$(terraform output db_address)"
cd ..

###
# Create the wordpress site
#
cd wordpress
# Prompt asking if db should be deployed
read -p "Create DB? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
  ./deploy_db.sh "$db_address" $1 $2 $3
fi
./deploy_site.sh "$db_address" $1 $2 $3

cd ..

###
# create the container to use the wordpress site 
# 
cd containers
./build.sh
./authenticate.sh
# Enter the authentication command here
read -p "Authentication Hash: " -r hash
docker login -u AWS -p $hash https://379709885387.dkr.ecr.us-west-2.amazonaws.com
./deploy.sh
cd ..

###
# 1. Create the Infrastructure that uses the containers
#
cd terraform-ecs
./deploy.sh
cd ..

