#!/bin/bash -eux
set +u
if [[ ${1} == "" ]]; then
	echo "Found no parameter"
	exit 1
fi
set -u

(while true; do echo "Packer is building AMI"; sleep 60; done) & # jobs %1
source ami_name.sh
AMI_NAME=$(name)
packer build -var "AMI_NAME=$AMI_NAME" packer.json
RESULT=$?
kill %1
if [[ $RESULT != 0 ]]; then
	exit $RESULT
fi


if [[ ${1} == "whale" ]]; then
	INSTANCE_TYPE='t2.medium'
	INSTANCE_NAME='whale'
	LOAD_BALANCER='whale'
	MIN_SIZE='2'
	DESIRED_CAPACITY='2'
	MAX_SIZE='5'
else
	INSTANCE_TYPE='t2.micro'
	INSTANCE_NAME='whale-dev'
	LOAD_BALANCER='whale-dev'
	MIN_SIZE='1'
	DESIRED_CAPACITY='1'
	MAX_SIZE='1'
fi

AWS_DEFAULT_REGION='us-east-1' DATE=$(date -u +%FT%TZ | sed 's/://g' | sed 's/-//g') terraform apply -var "launch_configuration_name=$DATE" -var "auto_scaling_group_name=$DATE" -var "load_balancers=$LOAD_BALANCER" -var "instance_type=$INSTANCE_TYPE" -var "min_size=$MIN_SIZE" -var "desired_capacity=$DESIRED_CAPACITY" -var "max_size=$MAX_SIZE" -var "image_id=$AMI_NAME" -var-file=terraform-dev.tfvars

#instanceIds=$(aws ec2 run-instances --image-id $AMI_NAME --subnet-id $SUBNET_ID --instance-type $INSTANCE_TYPE --security-group-id $SECURITY_GROUP_ID --key-name $KEY_NAME --associate-public-ip-address --count $COUNT | jq -r '.Instances[] .InstanceId')
#instanceIdBelongedElb=$(aws elb describe-load-balancers --load-balancer-names ${1} | jq -r '.LoadBalancerDescriptions[].Instances[].InstanceId')
#aws ec2 create-tags --resources $instanceIds --tags Key=Name,Value=$INSTANCE_NAME
#ipAddress=$(aws ec2 describe-instances --instance-ids $instanceIds | jq -r '.Reservations[].Instances[].PublicIpAddress')
#aws elb register-instances-with-load-balancer --load-balancer-name ${1} --instances $instanceIds

if [[ ${1} == "whale-dev" ]] then
	aws elb deregister-instances-from-load-balancer --instances $instanceIdBelongedElb
fi
