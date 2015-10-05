#!/bin/bash
set -x
set -e

instanceIds=$(aws ec2 run-instances --region ap-northeast-1 --image-id ami-936d9d93 --subnet-id subnet-377cc840  --instance-type t2.micro --security-group-id sg-93cd8ef6 --key-name code-check-prod --associate-public-ip-address --count 2 | jq -r '.Instances[] .InstanceId')
aws ec2 create-tags --region ap-northeast-1 --resources $instanceIds --tags Key=Name,Value=code-check-prod-$CIRCLE_SHA1-$(git rev-parse --short HEAD)


