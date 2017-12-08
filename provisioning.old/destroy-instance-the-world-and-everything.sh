#!/bin/sh

#Getting our variables
INSTANCE_ID=$(cat ./ec2_instance/instance-id.txt)
SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
SECURITY_GROUP_NAME=$(cat ./ec2_instance/security-group-name.txt)

#Kill the instance
aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}

#Wait until the instance is dead
aws ec2 wait --region eu-west-2 instance-terminated --instance-ids ${INSTANCE_ID}
#Delete the security group
aws ec2 delete-security-group --group-id ${SECURITY_GROUP_ID}
#Delete the ssh key pair
aws ec2 delete-key-pair --key-name ${SECURITY_GROUP_NAME}
#Remove our variables folder
rm  -rf ec2_instance

exit