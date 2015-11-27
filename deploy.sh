#!/bin/bash
(while true; do echo "Don't DIE!!!!"; sleep 60; done) & # jobs %1
source ami_name.sh
RESULT=`packer build -var "AMI_NAME=name" packer.json`
kill %1
exit $RESULT
