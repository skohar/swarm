#!/bin/bash
set -x
set -e
(while true; do echo "Don't DIE!!!!"; sleep 60; done) & # jobs %1

#instanceIds=$(aws ec2 run-instances --region ap-northeast-1 --image-id ami-936d9d93 --subnet-id subnet-377cc840  --instance-type t2.micro --security-group-id sg-93cd8ef6 --key-name code-check-prod --associate-public-ip-address --count 2 | jq -r '.Instances[] .InstanceId')
#instanceIdBelongedElb=$(aws elb describe-load-balancers --load-balancer-names codecheck-dev | jq -r '.LoadBalancerDescriptions[].Instances[].InstanceId')
#aws ec2 create-tags --region ap-northeast-1 --resources $instanceIds --tags Key=Name,Value=code-check-prod-$(echo $CIRCLE_SHA1 | cut -c 1-7)-$(git rev-parse --short HEAD)
#ipAddress=$(aws ec2 describe-instances --instance-ids i-f4514356 | jq -r '.Reservations[].Instances[].PublicIpAddress')
#ansible-playbook -i inventories/aws playbook.yml 
#aws elb register-instances-with-load-balancer --region ap-northeast-1 --load-balancer-name codecheck-dev --instances $instanceIds
#aws elb deregister-instances-from-load-balancer --region ap-northeast-1 --load-balancer-name codecheck-dev --instances $instanceIds
packer build -var "git_branch_name=$(git rev-parse --abbrev-ref HEAD)" -var "git_short_hash=$(git rev-parse --short HEAD)" packer.json
kill %1
