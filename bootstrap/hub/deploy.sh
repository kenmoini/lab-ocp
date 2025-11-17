#!/bin/bash

set -e

# This script deploys ArgoCD to a Hub OpenShift cluster.  It will:
# - Label some nodes
# - Create a Secret for Vault credentials
# - Install the OpenShift GitOps Operator
# - Wait for the ArgoCD Application Controller to be ready
# - [Optional Step not included] Create a Secret for Git credentials if needed
# - Apply the ArgoCD Application that self-configures ArgoCD and pulls in Hub GitOps configuration

oc label node raza cluster.ocs.openshift.io/openshift-storage='' --overwrite
oc label node suki cluster.ocs.openshift.io/openshift-storage='' --overwrite
oc label node endurance cluster.ocs.openshift.io/openshift-storage='' --overwrite

oc create secret generic bootstrap-vault-userpass -n kube-system --from-literal=password=$(cat $HOME/.hub-vault_pass.txt | tr -d '\n') --dry-run=client -o yaml | oc apply -f -

oc apply -k https://github.com/kenmoini/ocp4-gitops-config/openshift/openshift-gitops/operator/overlays/latest/

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
until [ "$(oc get -n openshift-gitops statefulset/openshift-gitops-application-controller -o jsonpath='{.status.availableReplicas}')" = "1" ]; do
  echo "ArgoCD is not ready yet. Retrying in 10 seconds..."
  sleep 10
done

# Apply the ArgoCD Application to self-configure ArgoCD
oc apply -f bootstrap-application.yaml

until $(oc get managedclusters.cluster.open-cluster-management.io/hub-cluster &>/dev/null); do echo "Waiting for ACM and Hub Cluster init..." && sleep 5; done

oc label managedclusters.cluster.open-cluster-management.io/hub-cluster community-eso=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster cluster-gitops-config=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster appset/kyverno=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster appset/vlan-stacks=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster appset/egress-ips=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster rhLoki=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster nvidia-gpu=enabled
oc label managedclusters.cluster.open-cluster-management.io/hub-cluster virtualization=enabled