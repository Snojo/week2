#!/bin/bash

ARN="arn:aws:iam::aws:policy/AmazonEC2FullAccess"
aws iam attach-role-policy --role-name StudentCICDServer --policy-arn $ARN 

aws iam create-instance-profile --instance-profile-name CICDServer-Instance-Profile

aws iam add-role-to-instance-profile --role-name cicd --instance-profile-name CICDServer-Instance-Profile

