#!/bin/sh

INSTANCE_PUBLIC_NAME=$(cat ./ec2_instance/instance-public-name.txt)
SECURITY_GROUP_NAME=$(cat ./ec2_instance/security-group-name.txt)

ssh -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME}