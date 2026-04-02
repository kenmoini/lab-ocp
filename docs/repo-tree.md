# Repository Tree

This repository is largely a mono-repo structure.  While there are other supporting repositories and ideally this would be broken out into other separate domain-specific repositories, this works as long as you know where everything is meant to go.

## General

- `.github/workflows/` - GitHub Actions (container image builds, vulnerability reporting)
- `absolutely-bonkers/` - KubeVirt Redfish ZTP test things (virtual BMH manifests)
- `docs/` - Documentation (GitOps workflow, policy placement, Vault setup, this file)
- `static/` - Static assets (architecture diagrams, screenshots)
- `README.md` - Repository overview

## Ansible Automation Platform

- `ansible/decision-environment/` - Assets to build the AAP Decision Environment
- `ansible/execution-environments/` - Example assets to build an EE but [an upstream build is used](https://github.com/kenmoini/ansible-ee-builder/tree/main/execution-environments/ztp-ee)
- `ansible/ocp-glue/` - Additional manifests used for ZTP workflows, K8s Secrets for Git Pull/Push
- `ansible/platform-configuration/` - Automation to setup AAP Controller/EDA for IaC/ZTP
- `ansible/playbooks/` - AAP Playbooks (HCP cluster creation, DNS, PVC expansion, virt-burner, etc.)
- `extensions/eda/rulebooks/` - AAP EDA Rulebooks

## Applications

- `apps/debug-receiver/` - Debug receiver deployment (namespace, deployment, service)
- `apps/guacamole/` - Apache Guacamole deployment
- `apps/simple-chat/` - Simple chat application

## Bootstrap

- `bootstrap/hub/` - Hub cluster bootstrap (ArgoCD Applications, deploy script)
- `bootstrap/hub/argo/` - Atomic ArgoCD Applications for ACM, storage, observability, policies, etc.

## Cluster Definitions

- `clusters/hub-cluster/` - Hub cluster configuration (GitOps config, Helm values, infrastructure)
- `clusters/endurance-sno/` - Endurance SNO cluster Helm values
- `clusters/hcp-bmh-duo/` - HCP bare-metal duo cluster (HostedCluster, NodePool, ManagedCluster)

## Configuration

- `configuration/catalogsources/` - OLM CatalogSource overrides (disabled internal, disconnected)
- `configuration/image-mirrors/` - ImageContentSourcePolicy / IDMS for disconnected registries
- `configuration/kagent/` - Kagent (Kubernetes AI agent) configuration
- `configuration/kyverno-policies/` - Kyverno ClusterPolicies (secret reloader, proxy injection, root CAs, RBAC)
- `configuration/networking/` - Networking configuration (MetalLB, NetworkAttachmentDefinitions, NNCPs)
- `configuration/nexusrm/` - Nexus Repository Manager instance configuration
- `configuration/rbac/` - RBAC definitions (groups, roles, app-specific bindings for Mattermost, Rocket.Chat, Vault)
- `configuration/storage/` - Storage configuration (StorageClass, StorageProfile)
- `configuration/system-configuration/` - Node-level config (ContainerRuntimeConfig, KubeletConfig, MachineConfig)
- `configuration/virtualization/` - OpenShift Virtualization (golden images, KubeVirt Redfish, migration, templates)
- `configuration/wto-customization/` - Web Terminal Operator customization (Containerfile, scripts, root CA)

## Containers

- `containers/keycloak/` - Custom Keycloak container image (theme JAR)
- `containers/kl-golden-ubi/` - Golden UBI base image with root CA
- `containers/kl-nodejs/` - Node.js UBI-based container image

## Tekton / OpenShift Pipelines

- `tekton/config/` - Pipeline configuration (namespace, RBAC, mirror registries, root CA)
- `tekton/imagestreams/` - ImageStreams for pipeline outputs
- `tekton/pipelines/` - Pipeline definitions (Keycloak build)
- `tekton/tasks/` - Custom Tasks (disconnected Buildah)

## Red Hat Advanced Cluster Management (RHACM)

- `rhacm/gitops/` - ArgoCD ApplicationSets for multi-cluster GitOps (ACS, cluster config, CSI, egress IPs, Vault, dev services, Kagent, KubeVirt Redfish, Mattermost, Rocket.Chat, VLAN stacks, ZTP sync, external XKS integration)
- `rhacm/managedclustersets/` - ManagedClusterSet definitions (external OCP, external XKS)
- `rhacm/mco/` - Multicluster Observability (MCO instance, Thanos rules, Grafana dashboards, alerts, network policies)
- `rhacm/mcsb/` - ManagedClusterSetBindings (global bindings for observability, monitoring, StackRox, etc.)
- `rhacm/placements/` - Placement rules for targeting clusters by label/version/capability
- `rhacm/placement-bindings/` - PlacementBindings linking PolicySets to Placements
- `rhacm/policies/` - Governance policies:
  - `policies/operators/` - Operator Subscriptions (35+ operators: AAP, ACS, ESO, GPU, ODF, Virt, Pipelines, etc.)
  - `policies/versioned-operators/` - Version-pinned operator subscriptions (AAP 2.6, GitOps 1.18, Logging 6.x, MTC 1.8, MTV, Loki, RHBK)
  - `policies/operator-instances/` - Operator CR instances (ACS Central, ESO, descheduler, MetalLB, NFD, etc.)
  - `policies/capabilities/` - Cluster capability configs (network diagnostics, OLM pprof, console, monitoring)
  - `policies/health-checks/` - Health check policies (ClusterOperator, ClusterVersion, MachineConfigPool, Node, MC addons)
  - `policies/maintenance/` - Maintenance policies (marketplace job cleanup)
  - `policies/managed-mcsb/` - Managed ManagedClusterSetBindings for RHDH/RHBK
  - Top-level policies: IDP config, ingress certs/crypto, etcd encryption, root CA, registry, HCP, RBAC, compliance scans, etc.
- `rhacm/policy-generators/` - PolicyGenerator inputs (ContainerRuntimeConfig, KubeletConfig, MachineConfigs, login banners)
- `rhacm/policy-sets/` - PolicySets grouping policies by scope (global, on-prem, developer services, health checks, operator/instance bundles for Virt/ODF/NVIDIA)
- `rhacm/targeted-placements/` - Targeted Placements & Bindings for specific integrations (ACS secured cluster, ESO, Loki, NetObserv, RHDH)
- `rhacm/targeted-policies/` - Targeted policies for specific clusters (ACS secured, monitoring config, Vault creds, RHDH/RHBK secrets)

## Red Hat Advanced Cluster Security (RHACS)

- `rhacs/policy-as-code/` - RHACS policy-as-code definitions (e.g., main tag policy)

## Zero Touch Provisioning

- `ztp-clusters/` - Base folder path for GitOps-driven ZTP clusters
- `ztp-clusters/{HUB_CLUSTER_NAME}/` - Folder for per-ACM Hub Cluster synced Managed Clusters
- `ztp-clusters/{HUB_CLUSTER_NAME}/argo/` - Contains all the atomic ArgoCD Applications
- `ztp-clusters/{HUB_CLUSTER_NAME}/spokes/{SPOKE_CLUSTER_NAME}/` - Per-cluster manifests for ZTP synced Managed Clusters
