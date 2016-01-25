#!/bin/bash -eux
set +u
if [[ ${1} == "" ]]; then
  echo "Found no parameter"
  exit 1
fi
set -u

source generate_ami_name.sh
AMI_NAME=$(generate_ami_name)
./deploy-packer.sh $AMI_NAME

if [[ ${1} == "whale" ]]; then
  INSTANCE_TYPE='t2.medium'
  INSTANCE_NAME='whale'
  LOAD_BALANCER='whale'
  MIN_SIZE='2'
  DESIRED_CAPACITY='2'
  MAX_SIZE='5'
  VAR_FILE='terraform-prod.tfvars'
else
  INSTANCE_TYPE='t2.micro'
  INSTANCE_NAME='whale-dev'
  LOAD_BALANCER='whale-dev'
  MIN_SIZE='1'
  DESIRED_CAPACITY='1'
  MAX_SIZE='1'
  VAR_FILE='terraform-dev.tfvars'
fi
DATE=$(date -u +%Y%m%dT%H%M%SZ)
./deploy-terraform.sh ${1}
