#!/bin/sh

set -x
set -e

ssh root@localhost -p $(docker port test_sshd 22 | awk -F "[:]" '{print $2}')
