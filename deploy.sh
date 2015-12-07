#!/bin/bash -eux
(while true; do echo "Don't DIE!!!!"; sleep 60; done) & # jobs %1
source ami_name.sh
AMI_NAME=`name`
RESULT=`packer build -var "AMI_NAME=$AMI_NAME" packer.json`
kill %1
exit $RESULT
