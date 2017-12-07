#!/usr/bin/env bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

DOCKER_USER=snojo
DOCKER_PASS=Penzdc08

sudo yum update
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum -y remove java-1.7.0-openjdk
sudo yum -y install java-1.8.0
sudo yum -y install git
sudo yum -y install pip

#NVM
sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash


sudo yum -y install docker

sudo service docker start
sudo usermod -a -G docker ec2-user

sudo yum install jenkins -y
sudo usermod -a -G docker jenkins

sudo service jenkins start
sudo pip install docker-compose
docker login --username=$DOCKER_USER --password=$DOCKER_PASS

sudo npm install -g nodemon
sudo npm install -g create-react-app
nvm install 6.9.1
nvm use 6.9.1

touch ec2-init-done.markerfile
