#!/usr/bin/env bash

USER="${SUDO_USER:-$(id -u -n)}"
GROUP="${SUDO_GID:-$(id -g -n)}"
echo "CGroup setup beginning for user $USER and group $GROUP."

mkdir /sys/fs/cgroup
mkdir /sys/fs/cgroup/init
echo 1 > /sys/fs/cgroup/init/cgroup.procs
echo 1 > /sys/fs/cgroup/cgroup.procs
echo 2 > /sys/fs/cgroup/init/cgroup.procs
echo 2 > /sys/fs/cgroup/cgroup.procs

chown "$USER":"$GROUP" /sys/fs/cgroup

for i in cgroup.procs cgroup.subtree_control cgroup.threads inner memory.oom.group memory.reclaim
do
  chown -R "$USER":"$GROUP" /sys/fs/cgroup/${i}
done

echo "CGroup setup completed for user $USER and group $GROUP."