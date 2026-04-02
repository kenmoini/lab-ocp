# Repository Tree

This repository is largely a mono-repo structure.  While there are other supporting repositories and ideally this would be broken out into other separate domain-specific repositories, this works as long as you know where everything is meant to go.

## General

- `.github/workflows/` - GitHub Actions
- `absolutely-bonkers/` - KubeVirt Redfish ZTP Test things

## Ansible Automation Platform

- `ansible/decision-environment` - Assets to build the AAP Decision Environment
- `ansible/execution-environment` - Example assets to build an EE but [an upstream build is used](https://github.com/kenmoini/ansible-ee-builder/tree/main/execution-environments/ztp-ee)
- `ansible/ocp-glue/` - Additional manifests used for ZTP workflows, K8s Secrets for Git Pull/Push
- `ansible/platform-configuration/` - Automation to setup AAP Controller/EDA for IaC/ZTP
- `ansible/playbooks/` - AAP Playbooks
- `extensions/eda/rulebooks/` - AAP EDA Rulebooks

## Zero Touch Provisioning

- `ztp-clusters/` - Base folder path for GitOps-driven ZTP clusters
- `ztp-clusters/{HUB_CLUSTER_NAME}/` - Folder for per-ACM Hub Cluster synced Managed Clusters
- `ztp-clusters/{HUB_CLUSTER_NAME}/argo/` - Contains all the atomic ArgoCD Applications
- `ztp-clusters/{HUB_CLUSTER_NAME}/spokes/{SPOKE_CLUSTER_NAME}/` - Per-cluster manifests for ZTP synced Managed Clusters

