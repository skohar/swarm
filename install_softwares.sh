#!/bin/bash -eu
CIRCLECI_CACHE_DIR="${HOME}/bin"
PACKER_URL="https://dl.bintray.com/mitchellh/packer/packer_0.8.6_linux_amd64.zip"
if [ ! -f "${CIRCLECI_CACHE_DIR}/packer" ]; then
    wget -O /tmp/packer.zip "${PACKER_URL}"
    unzip -d "${CIRCLECI_CACHE_DIR}" /tmp/packer.zip
fi
packer version

CIRCLECI_CACHE_DIR="${HOME}/bin"
PACKER_URL="https://releases.hashicorp.com/terraform/0.6.8/terraform_0.6.8_linux_amd64.zip"
if [ ! -f "${CIRCLECI_CACHE_DIR}/terraform" ]; then
	wget -O /tmp/terraform.zip "${TERRAFORM_URL}"
	unzip -d "${CIRCLECI_CACHE_DIR}" /tmp/terraform.zip
fi
terraform version
