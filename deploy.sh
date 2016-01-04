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
packer build -machine-readable -var "AMI_NAME=$AMI_NAME" packer.json
#packer build -machine-readable -var "AMI_NAME=$AMI_NAME" packer.json > packer-build.log
#RESULT=$?
#AMI_ID=$(tail -1 packer-build.log | awk '{print $6}')
#kill %1
#[ $RESULT != 0 ] && exit $RESULT
#if [[ ${1} == "whale" ]]; then
#    INSTANCE_TYPE='t2.medium'
#    INSTANCE_NAME='whale'
#    LOAD_BALANCER='whale'
#    MIN_SIZE='2'
#    DESIRED_CAPACITY='2'
#    MAX_SIZE='5'
#    VAR_FILE='terraform-prod.tfvars'
#else
#    INSTANCE_TYPE='t2.micro'
#    INSTANCE_NAME='whale-dev'
#    LOAD_BALANCER='whale-dev'
#    MIN_SIZE='1'
#    DESIRED_CAPACITY='1'
#    MAX_SIZE='1'
#    VAR_FILE='terraform-dev.tfvars'
#fi
#AWS_DEFAULT_REGION='us-east-1'
#DATE=$(date -u +%Y%m%dT%H%M%SZ)
#cd $HOME/whale-env/terraform/attach && terraform plan -var "launch_configuration_name=$DATE" -var "auto_scaling_group_name=$DATE" -var "load_balancers=$LOAD_BALANCER" -var "instance_type=$INSTANCE_TYPE" -var "min_size=$MIN_SIZE" -var "desired_capacity=$DESIRED_CAPACITY" -var "max_size=$MAX_SIZE" -var "image_id=$AMI_ID" -var-file=$VAR_FILE
#cd $HOME/whale-env/terraform/attach && terraform apply -var "launch_configuration_name=$DATE" -var "auto_scaling_group_name=$DATE" -var "load_balancers=$LOAD_BALANCER" -var "instance_type=$INSTANCE_TYPE" -var "min_size=$MIN_SIZE" -var "desired_capacity=$DESIRED_CAPACITY" -var "max_size=$MAX_SIZE" -var "image_id=$AMI_ID" -var-file=$VAR_FILE
