#!/bin/bash -eux
(while true; do echo "Packer is building AMI"; sleep 60; done) & # jobs %1
packer build -machine-readable -var "AMI_NAME=$AMI_NAME" packer.json > packer-build.log
RESULT=$?
kill %1
if [[ $RESULT == 0 ]]; then
  # parse 'amazon-ebs: AMIs were created: us-east-1: ami-6cdc8006'
  AMI_ID=$(tail -1 packer-build.log | awk '{print $6}')
  echo $AMI_ID
else
  exit $RESULT
fi
