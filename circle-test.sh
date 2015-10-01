#!/bin/sh

set -x
set -e

docker build -t eg_sshd .
docker run -d -P --name test_sshd eg_sshd
ansible-playbook -v -i 'localhost,' -u root -p $(docker port test_sshd 22 | awk -F "[:]" '{print $2}') playbook.yml
