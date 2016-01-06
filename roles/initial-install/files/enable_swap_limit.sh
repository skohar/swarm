#!/bin/bash -eux
sed -i '/^GRUB_CMDLINE_LINUX=""$/d' /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' >> /etc/default/grub
update-grub
