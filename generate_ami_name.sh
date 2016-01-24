#!/bin/bash -eux
generate_ami_name () {
  DATE_TIME=$(date -u +%Y%m%dT%H%M%SZ)
  AMI_NAME=whale-$DATE_TIME-$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)-$(cd env-builder && git checkout -q master && git rev-parse --abbrev-ref HEAD)-$(cd env-builder && git rev-parse --short HEAD)
  echo $AMI_NAME
}
