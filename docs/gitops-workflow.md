# GitOps Workflow

## Bootstrap

Bootstrapping assumes the use of the initial cluster functioning as a management cluster running things like ArgoCD and ACM.

Take that initial cluster, setup storage - this could be GitOps as well, however everyone's storage is different so this is out of scope and an easy day 1 task as a function of the cluster installation.  This repo assumes the use of LSO+ODF.

1. Install OpenShift GitOps Operator
2. Create a **Bootstrap AppOfApps** - this points to `bootstrap/hub/argo/` and inclusion is done by Kustomization file.

The `bootstrap/hub/deploy.sh` script performs those two steps.

## Bootstrap AppOfApps

As soon as the OpenShift GitOps operator is ready, the Bootstrap AppOfApps `bootstrap/hub/bootstrap-application.yaml` is deployed.  It syncs down the following ArgoCD Applications in sync waves:

- ArgoCD Self-Management - This takes the basic ArgoCD deployment and reconfigures it, Argo manages itself via GitOps.
- ACM Installation
- ACM Deployment
- ACM Configuration - GitOps integration, **AppSets**, ManagedClusterSetBindings, MultiClusterObservability, **Policies**, PolicyGenerators, Placements, etc.

Once those Applications are all synced, you'll see ACM configuring itself and the cluster with the Policies and other ACM configuration components.

## AppSets

ApplicationSets in ArgoCD provide a way to distribute Applications to multiple clusters under ArgoCD mangement with matrix list generators.  If you have a set of clusters in ArgoCD with the labels `env=prod` then you could deploy to both clusters with different configuration easily.

The combination of ACM and ArgoCD means any cluster managed under ACM is automatically imported into ArgoCD with all of their labels.  This makes for easier use of ApplicationSets now that you don't have to manage the Clusters in ArgoCD's inventory.