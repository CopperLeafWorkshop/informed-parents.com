#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

###
# Create a Key-Pair
#

# Check if the private key exists, if not:
#	if [ ! -f ./keys/informed-parents-uswest2.pem ]; then
#		# Try to download the keys from S3
#	fi
#	
#	# Check if the public key exists, if not:
#	if [ ! -f ./keys/informed-parents-uswest2.pub ]; then
#		# Try to download the keys from S3
#	fi

# Check if the private key exists now, if not:
if [ ! -f ./keys/informed-parents-uswest2.pem ]; then
	# Create AWS Key-Pair
	aws ec2 create-key-pair --key-name informed-parents-uswest2 --query 'KeyMaterial' --output text > ./keys/informed-parents-uswest2.pem
	chmod 400 ./keys/informed-parents-uswest2.pem
fi

if [ ! -f ./keys/informed-parents-uswest2.pub ]; then
	# Create the public key for terraform
	ssh-keygen -y -f ./keys/informed-parents-uswest2.pem  > ./keys/informed-parents-uswest2.pub
fi

# Sync with S3


###
# Run Terraform
#

terraform plan -var 'db_password=$1'
read -p "Apply? (y/n) : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply -var 'db_password=$1'
fi
