#!/bin/bash
#
# deploy.sh <sql-server-uri> <rds_admin_db_password> <wordpress_db_password> 
#

# create the database
mysql --host=$1 --user=shared_db_owner --password=$2 -v --port=5432 -e "select 'testing connection.'"
mysql --host=$1 --user=shared_db_owner --password=$2 -v --port=5432 -e "create database informed_parents_db"
mysql --host=$1 --user=shared_db_owner --password=$2 -v --port=5432 -e "grant all on informed_parents_db.* to 'site_user' identified by '$3'" 

