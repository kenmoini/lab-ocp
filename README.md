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
  - [Policy] Monitoring Configuration (Persistence + ACM)
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
  - `cluster-gitops-config=enabled` Deploys a per-cluster GitOps ApplicationSet of Applications.  Points to `clusters/{{name}}/gitops-config/`
  - `acs-secured-cluster=enabled` Deploys the ACS SecuredCluster CR integrated to the Hub ACS
  - `acs-central=enabled` Deploys the ACS Central CR to any cluster, by default an ACS Hub will be deployed on the ACM Hub
  - `nvidia-gpu=enabled` Deploys the NFD and NVIDIA GPU Operators and Instances
  - `virtualization=enabled` Deploys the Virtualization related Operators and Instances
  - `community-eso=enabled` Deploys the community External Secrets Operator with a ClusterSecretStore connecting to Vault.  Required for bootstrapping IDP and whatnot.
  - `appset/kyverno=enabled` AppSet that deploys Kyverno via Helm and Policies.
  - `appset/helm-vault=enabled` AppSet that deploys Hashicorp Vault via Helm.  Not really used since bootstrap needs managed Secrets but can be helpful for providing Vault as a service on managed clusters.
  - `appset/democratic-csi=enabled` AppSet that deploys Democratic CSI.
  - `developer-services=enabled` Deploys Developer Services (OpenShift Builds, DevSpaces, Pipelines, RHDP, etc)

- **Kyverno Policies**
  - Add Root CA Certificates to Pods
  - Add Proxy (and optionally Root CA Certificates) to Pods
  - Reload Pods with Changed ConfigMaps/Secrets

- **Per-Cluster GitOps**
  - Hub Cluster
    - Networking Configuration (NNCPs, NADs, EgressIPs, MetalLB)
    - Virtualization Hydration (Templates, Migration Providers)

---

## Kemo Notes

- Deploy Hub Cluster
- Install LSO+ODF
- Create Vault Userpass secret
- Run bootstrap script
- Label hub-cluster in ACM with:

```bash
until $(oc get managedclusters.cluster.open-cluster-management.io/hub-cluster &>/dev/null); do echo "Waiting for ACM and Hub Cluster init..." && sleep 5; done

oc label managedclusters.cluster.open-cluster-management.io/hub-cluster cluster-gitops-config=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster appset/kyverno=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster community-eso=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster rhLoki=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster nvidia-gpu=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster virtualization=enabled
```

---

## Todo

- Add ExternalDNS with PowerDNS and Route53
- Add cert-manager with sub-ca, StepCA ACME, and Let's Encrypt with R53