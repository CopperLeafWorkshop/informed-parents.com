#!/bin/bash
#
# deploy.sh <rds_admin_db_password> <wordpress_db_password> <wordpress_admin_password>
#
echo "begin"
cd terraform
./deploy.sh $1
 
db_address="$(terraform output db_address)"
echo "${db_address}"
cd ..
cd wordpress
./deploy.sh "$db_address" $1 $2 $3