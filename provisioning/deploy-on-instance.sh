#!/bin/sh

#Lets makes sure we have all our info in scope
INSTANCE_ID=$(cat ./ec2_instance/instance-id.txt)
INSTANCE_PUBLIC_NAME=$(cat ./ec2_instance/instance-public-name.txt)
SECURITY_GROUP_NAME=$(cat ./ec2_instance/security-group-name.txt)

#Lets make sure that we can connect to our instance.
status='unknown'
while [ ! "${status}" == "ok" ]
do
   status=$(ssh -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem"  -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 ec2-user@${INSTANCE_PUBLIC_NAME} echo ok 2>&1)
   sleep 2
done

echo "Starting SCP"

#Copy all the files we need to run on our new, beautiful, instance
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./ec2-instance-check.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/ec2-instance-check.sh
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./docker-compose.yaml ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose.yaml
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./.env ec2-user@${INSTANCE_PUBLIC_NAME}:~/.env
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./docker-compose-and-run.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose-and-run.sh
echo "SCP finished. Lets run the shit"
#Now lets run some commands and scripts on the instance.
#The Cats are mostly to make suer that the files got there securely and that we have full access
ssh -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "cat ~/ec2-instance-check.sh"
ssh -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "cat ~/docker-compose-and-run.sh"
#Running docker-compose to get our docker image and run it
ssh -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "sh ~/docker-compose-and-run.sh"
#echo "Something went wrong... You shouldn't be here. Your docker image should be running now."
echo "Your docker instance is now up and running"

exit