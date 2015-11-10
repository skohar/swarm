#!/bin/bash
(while true; do echo "Don't DIE!!!!"; sleep 60; done) & # jobs %1
packer build -var "git_branch_name=$(git rev-parse --abbrev-ref HEAD)" -var "git_short_hash=$(git rev-parse --short HEAD)" -var "env-builder_git_branch_name=$(git submodule foreach git rev-parse --abbrev-ref HEAD | grep -v 'Entering')" -var "env-builder_git_short_hash=$(git submodule foreach git rev-parse --short HEAD | grep -v 'Entering')" packer.json
kill %1
