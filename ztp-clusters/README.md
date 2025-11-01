# Zero Touch Provisioning Clusters

This folder holds the sync structure for manifests for syncing ZTP clusters.

1. This folder holds the ZTP Hub cluster named folders.
2. In each Hub Cluster folder there are two folders:
  - The `argo` folder holds the ArgoCD Applications that are individually synced per cluster
  - The `spokes` folder holds the individual named cluster manfests that the individual ArgoCD Applications are syncing to the Hub for creation and management.