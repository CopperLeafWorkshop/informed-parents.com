#!/bin/bash
#
# deploy.sh <rds_admin_db_password> <wordpress_db_password> <wordpress_admin_password>
#

###
# 1. Create the Infrastructure
#
cd terraform
./deploy.sh $1
db_address="$(terraform output db_address)"
cd ..

###
# 2. Create the wordpress ite
#
cd wordpress
./deploy.sh "$db_address" $1 $2 $3
cd ..

###
# 3. Configure container to user wordpress site 
# 
cd containers
./deploy.sh
cd..
