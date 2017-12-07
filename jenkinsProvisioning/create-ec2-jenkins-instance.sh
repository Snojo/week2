#!/bin/sh

USERNAME=$(aws iam get-user --query 'User.UserName' --output text)

#We're creating global env variables here
INSTANCE_DIR="ec2_instance"
SECURITY_GROUP_NAME="jenkins-${USERNAME}"

#If the INSTANCE_DIR directory doesn't exist, we're creating it.
if [ -d "${INSTANCE_DIR}" ]; then
    exit
fi

[ -d "${INSTANCE_DIR}" ] || mkdir ${INSTANCE_DIR}

#Creates a ssh keypair for our security group which is saved as .pem
aws ec2 create-key-pair --key-name ${SECURITY_GROUP_NAME} --query 'KeyMaterial' --output text > ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem
#Changing the rights so that the key can only be viewed by us.
chmod 400 ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem
#Creating and saving the security group ID
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name ${SECURITY_GROUP_NAME} --description "security group for dev environment in EC2" --query "GroupId"  --output=text)
#Put those babies into a file where we can have access to them in other scripts
echo ${SECURITY_GROUP_ID} > ./ec2_instance/security-group-id.txt
echo ${SECURITY_GROUP_NAME} > ./ec2_instance/security-group-name.txt
#Knowing your IP is very useful. We use that to create an ip for us to use
MY_PUBLIC_IP=$(curl http://checkip.amazonaws.com)
echo "Security group has been created"

MY_CIDR=${MY_PUBLIC_IP}/32
#We're opening the HTTP and SSH ports here 
set +e
echo Adding permissions. AWS console errors are ignored.
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${MY_CIDR}
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${MY_CIDR}
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${MY_CIDR}
set -e

echo "security group autorized"
#Lets create the instance with all our previously optained info along with the image of the OS (The ami). We're also making sure that they init our os correctly with our instance-init script.
INSTANCE_ID=$(aws ec2 run-instances --user-data file://jenkins-bootstrap.sh --image-id ami-15e9c770 --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${SECURITY_GROUP_NAME} --query 'Instances[0].InstanceId'  --output=text)
#Now lets save that instance id for later use
echo ${INSTANCE_ID} > ./ec2_instance/instance-id.txt
echo "I'm not hanging. I'm just warming up. Stay chill :-) "
#Lets wait until our instance instantiates 
aws ec2 wait --region us-east-2 instance-running --instance-ids ${INSTANCE_ID}
echo "Done warming up. Lets GO!"
#Lets make sure that we know our instance public dns so we can actually do something with it.
export INSTANCE_PUBLIC_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].PublicDnsName" --output=text)
echo ${INSTANCE_PUBLIC_NAME} > ./ec2_instance/instance-public-name.txt

set +e
echo "Lets copy some stuff"
scp -v -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@$(cat ./ec2_instance/instance-public-name.txt):/var/log/cloud-init-output.log ./ec2_instance/cloud-init-output.log
scp -v -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@$(cat ./ec2_instance/instance-public-name.txt):/var/log/user-data.log ./ec2_instance/user-data.log
echo "Copy finished"

echo "Lets make us gods"
aws ec2 associate-iam-instance-profile --instance-id $(cat ./ec2_instance/instance-id.txt) --iam-instance-profile Name=CICDServer-Instance-Profile

echo "Welcome to Godhood"


exit
