#!/bin/bash

set -e

# This script deploys ArgoCD to a Hub OpenShift cluster.  It will:
# - Install the OpenShift GitOps Operator
# - Wait for the ArgoCD Application Controller to be ready
# - [Optional Step not included] Create a Secret for Git credentials if needed
# - Apply the ArgoCD Application that self-configures ArgoCD and pulls in Hub GitOps configuration

oc create secret generic vault-userpass -n kube-system --from-literal=username=openshift --from-file=password=$HOME/.vault_pass.txt --dry-run=client -o yaml | oc apply -f -

oc apply -k https://github.com/kenmoini/ocp4-gitops-config/openshift/openshift-gitops/operator/overlays/latest/

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
until oc wait --for=condition=Available=True --timeout=10s statefulset/openshift-gitops-application-controller -n openshift-gitops; do
  echo "ArgoCD is not ready yet. Retrying in 10 seconds..."
  sleep 10
done

# Apply the ArgoCD Application to self-configure ArgoCD
oc apply -f bootstrap-application.yaml