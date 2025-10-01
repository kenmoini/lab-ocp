# RHEL 7 Golden Image

This VM golden image is simply based on the RHEL 7.9 KVM QCOW2.  The file is added to a Container Image, pushed to a registry, then OpenShift Virtualization can pull it in as a base image for your VMs.

This is useful in case your golden image pipeline already creates a QCOW2 asset, and if you want to pre-cache the VM image as a container.

> Download the RHEL 7.9 KVM QCOW2 from the Customer Portal

```bash
TARGET_REG="registry.example.com"
TARGET_PATH="containerdisks/rhel7-base-image"

podman build -t rhel7-golden-image -f Containerfile .
podman tag rhel7-golden-image $TARGET_REG/$TARGET_PATH:latest
podman tag rhel7-golden-image $TARGET_REG/$TARGET_PATH:7.9
podman push $TARGET_REG/$TARGET_PATH:latest
podman push $TARGET_REG/$TARGET_PATH:7.9
```