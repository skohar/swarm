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
	$INSTANCE_NAME='whale'
else
	$COUNT=$DEV_COUNT
	$INSTANCE_TYPE=$DEV_INSTANCE_TYPE
	$INSTANCE_NAME='whale-dev'
fi

instanceIds=$(aws ec2 run-instances --image-id $AMI_NAME --subnet-id $SUBNET_ID --instance-type $INSTANCE_TYPE --security-group-id $SECURITY_GROUP_ID --key-name $KEY_NAME --associate-public-ip-address --count $COUNT | jq -r '.Instances[] .InstanceId')
instanceIdBelongedElb=$(aws elb describe-load-balancers --load-balancer-names ${1} | jq -r '.LoadBalancerDescriptions[].Instances[].InstanceId')
aws ec2 create-tags --resources $instanceIds --tags Key=Name,Value=$INSTANCE_NAME
ipAddress=$(aws ec2 describe-instances --instance-ids $instanceIds | jq -r '.Reservations[].Instances[].PublicIpAddress')
aws elb register-instances-with-load-balancer --load-balancer-name ${1} --instances $instanceIds
