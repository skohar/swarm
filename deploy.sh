#!/bin/bash
(while true; do echo "Don't DIE!!!!"; sleep 60; done) & # jobs %1
DATE_TIME=`date -u +%FT%TZ | sed 's/://g' | sed 's/-//g'`
AMI_NAME=whale-$DATE_TIME-$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)-$(cd env-builder && git checkout -q master && git rev-parse --abbrev-ref HEAD)-$(cd env-builder && git rev-parse --short HEAD)
packer build -var $AMI_NAME packer.json
kill %1
