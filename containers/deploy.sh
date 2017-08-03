./build.sh
./authenticate.sh
# Enter the authentication command here
read -p "Authentication Hash: " -r hash
sudo docker login -u AWS -p $hash https://379709885387.dkr.ecr.us-west-2.amazonaws.com

sudo docker push 379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-wp
sudo docker push 379709885387.dkr.ecr.us-west-2.amazonaws.com/inpa-nginx

