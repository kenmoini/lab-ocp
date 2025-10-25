# Lab OpenShift

This is a repo for how I set up my OpenShift clusters in my homelab.

The goal is to provide an easy and GitOps-driven way to bootstrap things.

A base script installs GitOps, configures it with an AppOfApps pattern, including self-configuration.  Then it deploys ACM and a whole lot of ACM configuration.

## Prerequisites

- Vault - Some things like IDP Secrets need to easily be added where needed.  Sealed Secrets is lame.
- An OpenShift cluster or few.
- ODF on the clusters - if not, you just need to change some `storageClassName` definitions.

## Hub Cluster

I have a Hub cluster, 3 bare metal nodes that are pretty beefy.  I have it always deployed and use it as a Hub cluster for ACM and ACS.

## Included:

- Hub Cluster
  - [Policy] Hub Health Checks
  - [Policy] HCP ACM Infrastructure Credentials Integration
  - [Policy] Deploy ACS Central
- All OpenShift Clusters
  - [Policy] Health Checks
  - [Policy] MachineConfig{uration}s
  - [Policy] KubeletConfig
  - [Policy] Node Labeler
  - [Policy] Cluster Info Header with dynamic colors from a ConfigMap
  - [Policy] Removal of Kubeadmin
  - [Policy] Disabling of Self-Provisioner
  - [Policy] Audit Log Configuration
  - [Policy] Etcd Encryption
  - [Policy] Image Vulnerability Scanning
  - [Policy] OpenShift GitOps (Base Operator Install)
  - [Policy] OpenShift Logging (Base Operator Install)
  - [Policy] ACS Operator
  - [Policy] MetalLB Operator & Instance
  - [Policy] Web Terminal Operator
  - [Policy] Compliance Operator
  - [Policy] Node Maintenance Operator
  - [Policy] NMState Operator & Instance
  - [Policy] OADP Operator
- OpenShift 4.19 Clusters
  - [Policy] OpenShift GitOps 1.18 Operator & Instance
  - [Policy] OpenShift Logging 6.3 Operator & Instance
  - [Policy] OpenShift Loki 6.3 Operator & Instance (with `rhLoki=true` cluster label)
- Cluster Label Flagged
  - `acs-secured-cluster=true` Deploys the ACS SecuredCluster CR integrated to the Hub ACS
  - `acs-central=true` Deploys the ACS Central CR to any cluster
  - `nvidia-gpu=true` Deploys the NFD and NVIDIA GPU Operators and Instances
  - `virtualization=true` Deploys the Virtualization related Operators and Instances