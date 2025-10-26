# Lab OpenShift

This is a repo for how I set up my OpenShift clusters in my homelab.

The goal is to provide an easy and GitOps-driven way to bootstrap things.

A base script installs GitOps, configures it with an AppOfApps pattern, including self-configuration.  Then it deploys ACM and a whole lot of ACM configuration.

## Prerequisites

- Vault - Some things like IDP Secrets need to easily be added where needed.  Sealed Secrets is lame.
- An OpenShift cluster or few.
- ODF on the clusters - if not, you just need to change some `storageClassName` definitions and do something different for MCO and Loki object storage.

## Hub Cluster

I have a Hub cluster, 3 bare metal nodes that are pretty beefy.  I have it always deployed and use it as a Hub cluster for ACM and ACS.

## Included:

- **All OpenShift Clusters** `vendor=OpenShift`
  - [Policy] Health Checks
  - [Policy] Root CA Certificates
  - [Policy] Identity Providers
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
  - [Policy] Cluster Observability Operator
  - [Policy] Compliance Operator
  - [Policy] MetalLB Operator & Instance
  - [Policy] Node Maintenance Operator
  - [Policy] NMState Operator & Instance
  - [Policy] OADP Operator
  - [Policy] Secrets Store CSI Driver Operator
  - [Policy] Web Terminal Operator

- **Hub Cluster** `local-cluster=true`
  - [Policy] Hub Health Checks
  - [Policy] HCP ACM Infrastructure Credentials Integration
  - [Policy] Deploy ACS Central

- **OpenShift 4.19 Clusters** `openshiftVersion-major-minor=4.19`
  - [Policy] OpenShift GitOps 1.18 Operator & Instance
  - [Policy] OpenShift Logging 6.3 Operator, Instance, and UI Plugin (when used with Loki)
  - [Policy] OpenShift Loki 6.3 Operator & Instance (with `rhLoki=true` cluster label)

- **Cluster Label Flagged**
  - `acs-secured-cluster=true` Deploys the ACS SecuredCluster CR integrated to the Hub ACS
  - `acs-central=true` Deploys the ACS Central CR to any cluster
  - `nvidia-gpu=true` Deploys the NFD and NVIDIA GPU Operators and Instances
  - `virtualization=true` Deploys the Virtualization related Operators and Instances
  - `community-eso=true` Deploys the community External Secrets Operator with a ClusterSecretStore connecting to Vault.  Required for bootstrapping IDP and whatnot.
  - `cluster-gitops-config=enabled` Deploys a per-cluster GitOps ApplicationSet of Applications.  Points to `clusters/{{name}}/gitops-config/`
  - `appset/kyverno=enabled` AppSet that deploys Kyverno via Helm and Policies.
  - `appset/helm-vault=enabled` AppSet that deploys Hashicorp Vault via Helm.  Not really used since bootstrap needs managed Secrets but can be helpful for providing Vault as a service on managed clusters.
  - `appset/democratic-csi=enabled` AppSet that deploys Democratic CSI.

- **Kyverno Policies**
  - Add Root CA Certificates to Pods
  - Add Proxy (and optionally Root CA Certificates) to Pods
  - Reload Pods with Changed ConfigMaps/Secrets

---

## Kemo Notes

- Deploy Hub Cluster
- Install LSO+ODF
- Create Vault Userpass secret
- Run bootstrap script