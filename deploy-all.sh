#!/bin/bash -eux
set +u
if [[ ${1} == "" ]]; then
  echo "Found no parameter"
  exit 1
fi
set -u

source generate_ami_name.sh
AMI_NAME=$(generate_ami_name)
export AMI_ID=$(./deploy-packer.sh $AMI_NAME)

if [[ ${1} == "whale" ]]; then
  export INSTANCE_NAME='whale'
  export LOAD_BALANCER='whale'
  export MIN_SIZE='2'
  export DESIRED_CAPACITY='2'
  export MAX_SIZE='5'
  export VAR_FILE='terraform-prod.tfvars'
else
  export INSTANCE_NAME='whale-dev'
  export LOAD_BALANCER='whale-dev'
  export MIN_SIZE='1'
  export DESIRED_CAPACITY='1'
  export MAX_SIZE='1'
  export VAR_FILE='terraform-dev.tfvars'
fi
export DATE=$(date -u +%Y%m%dT%H%M%SZ)
./deploy-terraform.sh
