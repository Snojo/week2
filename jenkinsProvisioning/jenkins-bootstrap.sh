#!/usr/bin/env bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

DOCKER_USER=snojo
DOCKER_PASS=Penzdc08


sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum update
sudo yum -y remove java-1.7.0-openjdk
sudo yum -y install java-1.8.0
sudo yum -y install git
#sudo yum -y install pip




sudo yum -y install docker

sudo service docker start
sudo usermod -a -G docker ec2-user

sudo yum install jenkins -y
sudo usermod -a -G docker jenkins

sudo service jenkins start
sudo pip install docker-compose

#Into the jenkins machine
# sudo su -s /bin/bash jenkins 
sudo yum install -y nodejs npm --enablerepo=epel

#NVM
sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

nvm install 6.9.1
nvm use 6.9.1

sudo npm install -g yarn

cd /var/lib/jenkins/


# echo "[default]
# aws_access_key_id=AKIAI2L5IWFFXJK546IA
# aws_secret_access_key=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
# region=us-east-2
# output=json" >> ./.aws/config

# docker login --username=$DOCKER_USER --password=$DOCKER_PASS

# echo "-----BEGIN RSA PRIVATE KEY-----
# MIIEpQIBAAKCAQEAtH6jktt8J5M7yRFFix0aa2jVLGrfu7BfHwqmSLFchC2oKKHA
# m+MKOo7Z1ZSHomR2V3UVQTK3XUHF0Rg1u1BkAJtJDzethUbp2yd81UBRZWf3tx+U
# PSHm5cQihXpmCx8TYPo89+Ky/vNweIgMLTDfNOkIa8FYun4tadpsiii45lEKSh4L
# Bg0d0bHZmURunr+ls6l3mojmicU2WkyowCf1jHFxHpbHAmOFjlfBjR/cUZVH3Oo/
# y0mta+g3v19vEQnFPQ72yw8jaCQNi7euv2MPTyjZB4Zrx+lMjiarwrnj6aBxFUjb
# RnuChqyV1LZEyeVIlktg52upKr83vv44L8kTTQIDAQABAoIBAQCdw+OuRfLrlKI5
# ScODqViiceuC+5e8MpmyRFi8SWsYjd/iRCBbIcSbEqoNKdq0cyONpmWBq5bjCM6j
# yYmNxOLkNNdTWdNuH2HhkU5oB+QdwxafFhc4qB1u0FVsXmQ7bFo/9fq8oYbbmmXA
# tQoPphwz30zhAwtPV2LSl30v9hBIHy4bH/dWjqKBPj/lYkTDsHdgXYk1q1l2gamc
# trjPZfOxFfUIoe5ko1HPYUhJPbFCUEjUmXE/+knUkTo2zhd5lMWM48s7i8WIe03H
# ikE1c+7/hvYdSWyJQHb1sTVIqitV7IgIkTj5AFgSx8q45WoUOQ1u20N3kQzzw0eQ
# sFZfYHBxAoGBANcfulvNWrnMldf7wENgvodIqn8RmUiiqBQh2U4AahcPBghLFepC
# +HbFUQgVJnA5lk3ClbiOmLXyDw2PFTNnHSFoKUQCwK56/BD0UZuyMwbQXKIKu3u5
# IZPKCf8anom7smLt7Jc7wi6teS1IUa90qVyJQU8dnu1fJ47xsoB1LSVDAoGBANbK
# cMIxwI++rNllcq0+lrnYP8OEyUt8oZxtU2vh6G+Aym2R0HMt60Uv8QrmVLiMd9bi
# LAf9jkwfizIgF9SzSkuf8WgQechw83mn7wkq39J+qfCAfHRhc5RFlgUv9zmlG9gu
# gVDHBbA3g66eYBngAhYYZ78U+7V/1WM/Rcl/shQvAoGBAKmgHvYcKpmus8imfaej
# NRi/N5ESc2dOunGFby+OLBkag4suiY06WWhtlcNlyfVbsySFdkEcT1XIFA6A8Bqk
# B9g7pa427W+nEfLccyztikapLSGojMS16b/6437/olrAYZyYNqHZQPhFWPNXvvE2
# cATDRXf4x0Qsb6jK9BFOU9a5AoGAfPlFKniwRfL3t3Yjh1HHeVKtpyF3zggyMEYc
# J8VF7LrPDXmuA5ZQMe13HpRt7wMsJ0dpvyx0wy4HW574vrWjIOVrHNWZRlsSD1L6
# 7iaYHG2+i0T3JPAew8LJSzNhcZTz4pEMhOeIE8P5Rny4BdYk4J5Knw+idTRwAFMs
# U9WM09kCgYEAu1hgEdSHiB+3UwyZKDuEKyb53WAdD0y5MuQIg+UPhPrlRuLDgsRW
# 54TkPj7lilDl8c/Jng2s3U9woIJpAsShLGPNM/BMFnPq+D6P3JCQXL7d74kPjXKy
# G2enT2gWj51F1h4daGcY28DvPHiHZCNi9WitmgpqlOgLSb65k83UFGc=
# -----END RSA PRIVATE KEY-----
# " >> .ssh/rsa_id
exit

touch ec2-init-done.markerfile
