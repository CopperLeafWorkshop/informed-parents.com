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
./deploy.sh "$db_address" $1 $2 $3
cd ..

###
# create the container to use the wordpress site 
# 
cd containers
./deploy.sh
cd..

###
# 1. Create the Infrastructure that uses the containers
#
cd terraform-ecs
./deploy.sh
cd ..

