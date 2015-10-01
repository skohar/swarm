#!/bin/sh

set -x
set -e

docker run -d -P --name test_sshd eg_sshd
ssh root@localhost -p $(docker port test_sshd 22 | awk -F "[:]" '{print $2}')
