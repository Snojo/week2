function create-key-pair(){
    if [ ! -e ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem ]; then
        aws ec2 create-key-pair --key-name ${SECURITY_GROUP_NAME} --query 'KeyMaterial' --output text > ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem
        chmod 400 ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem
        echo "Key Pair Created"
    fi

}

function create-security-group(){
    SECURITY_GROUP_NAME=${1}
    if [ ! -e ./ec2_instance/security-group-id.txt ]; then
        export SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name ${SECURITY_GROUP_NAME} --description "security group for dev environment in EC2" --query "GroupId"  --output=text)
        echo ${SECURITY_GROUP_ID} > ./ec2_instance/security-group-id.txt
        echo "Security Group Created"
    else
        export SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
    fi
}

function delete-security-group(){
    SECURITY_GROUP_NAME=${1}
    PEM_NAME=$2
    if [ -e ./ec2_instance/security-group-id.txt ]; then
        SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
        aws ec2 delete-security-group --group-name ${SECURITY_GROUP_NAME}
        echo "Security Group Deleted"
        aws ec2 delete-key-pair --key-name ${SECURITY_GROUP_NAME}
        rm ./ec2_instance/security-group-id.txt
        rm -f ./ec2_instance/${PEM_NAME}.pem
    fi
}

function create-ec2-instance(){
    USERNAME=$(aws iam get-user --query 'User.UserName' --output text)
    PEM_NAME=hgop-${USERNAME}

    AMI_IMAGE_ID=$1
    SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
    INSTANCE_INIT_SCRIPT=${THISDIR}/jenkins-bootstrap.sh

    echo "Creating using AMI: ${AMI_IMAGE_ID}, SecurityGroup: ${SECURITY_GROUP_ID}, INSTANCEINITSCRIPT: ${INSTANCE_INIT_SCRIPT} and PEMNAME: ${PEM_NAME}"

    if [ ! -d ./ec2_instance/ ]; then
        mkdir ./ec2_instance/
    fi

    if [ ! -e ./ec2_instance/instance-id.txt ]; then
        set -e
        echo aws ec2 run-instances  --user-data file://${INSTANCE_INIT_SCRIPT} --image-id ${AMI_IMAGE_ID} --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${PEM_NAME}.pem --query 'Instances[0].InstanceId'  --output=text

        INSTANCE_ID=$(aws ec2 run-instances  --user-data file://jenkins-bootstrap.sh --image-id ${AMI_IMAGE_ID} --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${PEM_NAME}.pem --query 'Instances[0].InstanceId'  --output=text)
        echo ${INSTANCE_ID} > ./ec2_instance/instance-id.txt

        echo aws ec2 wait --region us-east-2 instance-running --instance-ids ${INSTANCE_ID}
        aws ec2 wait --region us-east-2 instance-running --instance-ids ${INSTANCE_ID}
        export INSTANCE_PUBLIC_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].PublicDnsName" --output=text)
    fi

    if [ ! -e ./ec2_instance/instance-public-name.txt ]; then
        echo ${INSTANCE_PUBLIC_NAME} > ./ec2_instance/instance-public-name.txt
    fi
}


function authorize-access(){
    SECURITY_GROUP_NAME=$1
    MY_PUBLIC_IP=$(curl http://checkip.amazonaws.com)
    MY_CIDR=${MY_PUBLIC_IP}/32

    echo Adding permissions. AWS console errors are ignored.
    set +e
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${MY_CIDR}
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${MY_CIDR}
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${MY_CIDR}
    set -e
}

