[![Circle CI](https://circleci.com/gh/givery-technology/whale-env.svg?style=svg&circle-token=616e448275061bd316259148d8e22bc91e823937)](https://circleci.com/gh/givery-technology/whale-env)

# whale-env
Sandbox of Test Server for codecheck

## Deploy on your environment
### All
*This script will affect AWS infrastructure of develop environment.*
```
AWS_DEFAULT_REGION='us-east-1' # from CircleCI
PACKER_LOG='1' # from circle.yml
source generate_ami_name.sh && packer validate -var "AMI_NAME=$(generate_ami_name)" packer.json # from circle.yml
source generate_ami_name.sh && packer build -var "AMI_NAME=$(generate_ami_name)" packer.json # from deploy-all.sh
./deploy-all.sh "whale-dev" # from circle.yml
```

## Run test on your environment
### Packer
*This script create AMI on AWS*
```
AWS_DEFAULT_REGION='us-east-1' # from CircleCI
PACKER_LOG='1' # from circle.yml
source generate_ami_name.sh && packer validate -var "AMI_NAME=$(generate_ami_name)" packer.json # from circle.yml
source generate_ami_name.sh && packer build -var "AMI_NAME=$(generate_ami_name)" packer.json # from deploy-all.sh
```

### Terraform
```
INSTANCE_TYPE='t2.small' # from deploy-all.sh
INSTANCE_NAME='whale-dev' # from deploy-all.sh
LOAD_BALANCER='whale-dev' # from deploy-all.sh
MIN_SIZE='1' # from deploy-all.sh
DESIRED_CAPACITY='1' # from deploy-all.sh
MAX_SIZE='1' # from deploy-all.sh
VAR_FILE='terraform-dev.tfvars' # from deploy-all.sh
terraform plan -var "launch_configuration_name=$DATE" -var "auto_scaling_group_name=$DATE" -var "load_balancers=$LOAD_BALANCER" -var "instance_type=$INSTANCE_TYPE" -var "min_size=$MIN_SIZE" -var "desired_capacity=$DESIRED_CAPACITY" -var "max_size=$MAX_SIZE" -var "image_id=$AMI_ID" -var-file=terraform/attach/terraform-dev.tfvars terraform/attach # from deploy-all.sh
```
