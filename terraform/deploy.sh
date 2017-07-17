#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

# create a key-pair
if [ ! -f informed-parents-uswest2.pem ]; then
	# Create AWS KeyPair
	aws ec2 create-key-pair --key-name informed-parents-uswest2 --query 'KeyMaterial' --output text > informed-parents-uswest2.pem
	chmod 400 ./informed-parents-uswest2.pem
fi
if [ ! -f informed-parents-uswest2.pub ]; then
	# Create the public key for terraform
	ssh-keygen -y -f informed-parents-uswest2.pem  > informed-parents-uswest2.pub
fi

terraform plan -var 'db_password=$1'
read -p "Apply? (y/n) : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply -var 'db_password=$1'
fi
