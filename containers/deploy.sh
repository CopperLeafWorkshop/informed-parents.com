#$ sudo docker-compose up

# The following example tags an image with the ID e9ae3c220b23 as aws_account_id.dkr.ecr.region.amazonaws.com/my-web-app.

#$ docker tag e9ae3c220b23 aws_account_id.dkr.ecr.region.amazonaws.com/my-web-app

# Push the image using the docker push command.
#$ docker push aws_account_id.dkr.ecr.region.amazonaws.com/my-web-app