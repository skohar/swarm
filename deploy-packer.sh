#!/bin/bash -eux
AMI_NAME=${1}
packer build -machine-readable -var "AMI_NAME=$AMI_NAME" packer.json > packer-build.log
cat packer-build.log
AMI_ID=$(tail -1 packer-build.log | awk '{print $6}') # parse 'amazon-ebs: AMIs were created: us-east-1: ami-6cdc8006'
echo $AMI_ID
