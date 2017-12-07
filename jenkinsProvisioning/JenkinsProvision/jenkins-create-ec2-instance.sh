#!/usr/bin/env bash

THISDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${THISDIR}/common-aws-functions.sh

USERNAME=$(aws iam get-user --query 'User.UserName' --output text)

PEM_NAME=hgop-${USERNAME}
JENKINS_SECURITY_GROUP=jenkins-${USERNAME}

 if [ ! -d ./ec2_instance/ ]; then
        mkdir ./ec2_instance/
        echo "Created the ec2_instance directory"
    fi

if [ ! -e ./ec2_instance/${PEM_NAME}.pem ]; then
        aws ec2 create-key-pair --key-name ${JENKINS_SECURITY_GROUP} --query 'KeyMaterial' --output text > ./ec2_instance/${PEM_NAME}.pem
        chmod 400 ./ec2_instance/${PEM_NAME}.pem
fi

if [ ! -e ./ec2_instance/security-group-id.txt ]; then
    SECURITY_GROUP_ID=$(create-security-group ${JENKINS_SECURITY_GROUP})
    echo "Security Group Created: ${JENKINS_SECURITY_GROUP}"
else
    SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
fi


if [ ! -e ./ec2_instance/instance-id.txt ]; then
    JBOOTSTRAP=${THISDIR}/jenkins-bootstrap.sh
    echo "Creating Jenkins Instance"
    create-ec2-instance ami-15e9c770  ${JBOOTSTRAP} ${PEM_NAME}
    echo "Instance Created"
fi
#Template: ami-1a962263 
#Last one I used:  ami-15e9c770

authorize-access ${JENKINS_SECURITY_GROUP}
echo "Access Authorized"

set +e
echo "Lets copy some stuff"
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${PEM_NAME}.pem" ec2-user@$(cat ./ec2_instance/instance-public-name.txt):/var/log/cloud-init-output.log ./ec2_instance/cloud-init-output.log
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${PEM_NAME}.pem" ec2-user@$(cat ./ec2_instance/instance-public-name.txt):/var/log/user-data.log ./ec2_instance/user-data.log
echo "Copy finished"

echo "Lets make us gods"
aws ec2 associate-iam-instance-profile --instance-id $(cat ./ec2_instance/instance-id.txt) --iam-instance-profile Name=CICDServer-Instance-Profile

echo "Welcome to Godhood"



