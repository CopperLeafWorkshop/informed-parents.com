#!/bin/bash
#
# deploy.sh <sql-server-uri> <rds_admin_db_password> <wordpress_db_password> <wordpress_admin_site_password>
#

# create the database
mysql --host=$1 --user=informed_parents --password=$2 -v --port=5432 -e "select 'testing connection.'"
mysql --host=$1 --user=informed_parents --password=$2 -v --port=5432 -e "create database informed_parents_db"
mysql --host=$1 --user=informed_parents --password=$2 -v --port=5432 -e "grant all on informed_parents_db.* to 'site_user' identified by '$3'" 

# cleanup any previous builds
rm -rf ./site
mkdir site
cd site

# build the site
wp core download
wp core config --dbname=informed_parents_db --dbuser=site_user --dbpass=$3 --dbhost=$1:5432 --dbprefix=wp_
wp core install --url="http://informed-parents.org" --title="Informed Parents" --admin_user="admin_user" --admin_password="$4" --admin_email="admin@informed-parents.org"

###
# Plugins
#
# wp plugin search wordpress-seo
# wp plugin install wordpress-seo
# wp plugin activate wordpress-seo
	
###
# Themes
#
# wp theme search twentytwelve
# wp theme install twentytwelve
# wp theme activate twentytwelve

###
# Updates
#
# wp plugin update --all
# wp theme update --all
# wp core update
# wp core update-d