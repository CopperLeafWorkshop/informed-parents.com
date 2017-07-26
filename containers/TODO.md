sudo docker build -t "379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-wp" -f ./dockerfile-php .
sudo docker push  379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-wp

sudo docker build -t "379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-nginx" -f ./dockerfile-nginx .
sudo docker push  379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-nginx
