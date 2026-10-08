#!/usr/bin/env bash

USER="${SUDO_USER:-$(id -u -n)}"
GROUP="${SUDO_GID:-$(id -g -n)}"

mkdir /sys/fs/cgroup/inner
echo 1 > /sys/fs/cgroup/inner/cgroup.procs
echo 2 > /sys/fs/cgroup/inner/cgroup.procs

chown "$USER":"$GROUP" /sys/fs/cgroup

for i in cgroup.procs cgroup.subtree_control cgroup.threads inner memory.oom.group memory.reclaim
do
  chown -R "$USER":"$GROUP" /sys/fs/cgroup/${i}
done

echo "CGroup setup completed for user $USER and group $GROUP."