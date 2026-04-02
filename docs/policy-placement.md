# RHACM Policy & Placement Reference

This document maps all GitOps ApplicationSets, Placements, Policies, PolicySets, PolicyGenerators, and PlacementBindings in the `rhacm/` directory.

---

## Table of Contents

- [RHACM Policy \& Placement Reference](#rhacm-policy--placement-reference)
  - [Table of Contents](#table-of-contents)
  - [ApplicationSets](#applicationsets)
  - [Placements](#placements)
    - [Core Placements](#core-placements)
    - [Version-Specific Placements](#version-specific-placements)
    - [Feature Placements](#feature-placements)
    - [HCP Placements](#hcp-placements)
    - [Targeted Placements (Namespace-Scoped)](#targeted-placements-namespace-scoped)
  - [PolicySets](#policysets)
    - [Global PolicySets](#global-policysets)
    - [Feature PolicySets](#feature-policysets)
    - [Operator \& Instance Bundle PolicySets](#operator--instance-bundle-policysets)
    - [On-Premises PolicySets](#on-premises-policysets)
    - [HCP PolicySets](#hcp-policysets)
  - [PolicyGenerators](#policygenerators)
  - [PlacementBindings](#placementbindings)
    - [Global Bindings](#global-bindings)
    - [Feature Bindings](#feature-bindings)
    - [Version-Specific Bindings](#version-specific-bindings)
    - [HCP Bindings](#hcp-bindings)
    - [Targeted Bindings](#targeted-bindings)

---

## ApplicationSets

All ApplicationSets live in `rhacm/gitops/`.  These ApplicationSets are synced with the Hub Cluster's ArgoCD platform instance to ArgoCD managed clusters that have specific labels.  The RHACM integration with ArgoCD automatically imports RHACM managed clusters into ArgoCD as managed clusters with the labels that exist in RHACM.

| Name | File | Cluster Selector Labels | Deployment Type |
|------|------|------------------------|-----------------|
| cluster-config | appset-cluster-config.yaml | `cluster-gitops-config=enabled` | Kustomize (clusters/{{name}}/gitops-config/) |
| acs-policies | appset-acs-central.yaml | `local-cluster=true` | Kustomize (rhacs/policy-as-code) |
| hub-dev-services | appset-hub-dev-services.yaml | `local-cluster=true` + `policy.kemo.dev/developer-services=true\|enabled` | Kustomize + Tekton |
| ztp-sync | appset-ztp-sync.yaml | `hcpServices=enabled\|true` | Git (ztp-clusters/{{name}}/argo/) |
| ext-xks-argocd | appset-ext-xks-argocd.yaml | `appset/ext-xks-argocd=enabled` | Helm: argo-cd v9.4.15 |
| ext-xks-rhacs | appset-ext-xks-rhacs.yaml | `ensemble/ext-xks-rhacs=enabled` | Helm: stackrox-secured-cluster-services v4.9.4 |
| democratic-csi-nfs | appset-democratic-csi-nfs.yaml | `appset/democratic-csi=enabled` | Helm: democratic-csi v0.15.0 |
| egress-ips | appset-egress-ips.yaml | `appset/egress-ips=enabled` | Helm: egressip (kenmoini/helm-things) |
| hashicorp-vault | appset-hashicorp-vault.yaml | `appset/helm-vault=enabled` | Helm: vault v0.31.0 |
| kagent | appset-kagent.yaml | `appset/helm-kagent=enabled` | Helm: kagent v0.7.4 (OCI) |
| kagent-crds | appset-kagent-crds.yaml | `appset/helm-kagent=enabled` | Helm: kagent-crds v0.7.4 (OCI) |
| kagent-kmcp | appset-kagent-kmcp.yaml | `appset/helm-kagent=enabled` | Helm: kagent-kmcp v0.1.8 (OCI) |
| kubevirt-redfish | appset-kubevirt-redfish.yaml | `virtualization=enabled\|true` | Helm: kubevirt-redfish v0.2.3 |
| kyverno | appset-install-kyverno.yaml | `appset/kyverno=enabled` | Helm: kyverno v3.6.1 |
| mattermost | appset-mattermost.yaml | `appset.kemo.dev/helm-mattermost=true\|enabled` | Helm: mattermost-team-edition v6.6.84 |
| rocketchat | appset-rocketchat.yaml | `appset/helm-rocketchat=enabled` | Helm: rocketchat v6.27.1 |
| vlan-stacks | appset-vlan-stacks.yaml | `appset/vlan-stacks=enabled` | Helm: ocp-networking (kenmoini/helm-things) |

---

## Placements

### Core Placements

Defined in `rhacm/placements/`.

| Name | File | Label Selectors | Notes |
|------|------|----------------|-------|
| global | global.yaml | ClusterSet: `global` | Tolerates unreachable/unavailable |
| all-openshift-clusters | all-openshift-clusters.yaml | `vendor=OpenShift`, `cloud!=KubeVirt` | Tolerates unreachable/unavailable |
| hub-cluster | hub-cluster.yaml | `local-cluster=true` | Tolerates unreachable/unavailable |
| onprem-openshift-clusters | onprem-openshift-clusters.yaml | `vendor=OpenShift`, `location=kemo-labs-rdu`, `cloud!=KubeVirt` | Tolerates unreachable/unavailable |
| global-hub-cluster | global-hub-cluster.yaml | `global-hub=true\|enabled` | No tolerations |

### Version-Specific Placements

| Name | File | Label Selectors |
|------|------|----------------|
| hub-4.19-clusters | hub-4.19-clusters.yaml | `local-cluster=true` + `openshiftVersion-major-minor=4.19` |
| hub-4.20-clusters | hub-4.20-clusters.yaml | `local-cluster=true` + `openshiftVersion-major-minor=4.20` |
| openshift-4.19-clusters | openshift-4.19-clusters.yaml | `openshiftVersion-major-minor=4.19` + `cloud!=KubeVirt` |
| openshift-4.20-clusters | openshift-4.20-clusters.yaml | `openshiftVersion-major-minor=4.20` + `cloud!=KubeVirt` |
| developer-services-4.19 | developer-services.yaml | `policy.kemo.dev/developer-services=true\|enabled` + `openshiftVersion-major-minor=4.19` |
| virtualization-4.19 | virtualization.yaml | `virtualization=true\|enabled` + `openshiftVersion-major-minor=4.19` |
| virtualization-4.20 | virtualization.yaml | `virtualization=true\|enabled` + `openshiftVersion-major-minor=4.20` |
| rh-loki-4.19 | rh-loki.yaml | `rhLoki=true\|enabled` + `openshiftVersion-major-minor=4.19` |

### Feature Placements

| Name | File | Label Selectors |
|------|------|----------------|
| developer-services | developer-services.yaml | `policy.kemo.dev/developer-services=true\|enabled` |
| hub-developer-services | hub-developer-services.yaml | `local-cluster=true` + `policy.kemo.dev/developer-services=true\|enabled` |
| virtualization | virtualization.yaml | `virtualization=true\|enabled` |
| enhanced-metrics | enhanced-metrics.yaml | `policy.kemo.dev/enhanced-metrics=true\|enabled` |
| nvidia-gpu | nvidia-gpu.yaml | `nvidia-gpu=true\|enabled` |
| bmh-lso-odf | bmh-lso-odf.yaml | `bmh-lso-odf=enabled\|true` |
| acs-central | acs-central.yaml | `acs-central=true\|enabled` |
| kyverno-policies | kyverno-policies.yaml | `kyverno-policies=true\|enabled` |
| servicemesh2 | servicemesh.yaml | `servicemesh2=true\|enabled` + `servicemesh3!=true\|enabled` |
| servicemesh3 | servicemesh.yaml | `servicemesh3=true\|enabled` + `servicemesh2!=true\|enabled` |
| community-eso | community-eso.yaml | `community-eso=true\|enabled` |

### HCP Placements

| Name | File | Label Selectors |
|------|------|----------------|
| hcp-inception | hcp-inception.yaml | `hcpType=inception` |
| hcp-kubevirt | hcp-kubevirt.yaml | `hcpType=kubevirt` |
| hcp-baremetal | hcp-baremetal.yaml | `hcpType=baremetal` |
| hcp-services | hcp-services.yaml | `hcpServices=enabled\|true` |
| all-hcp-virt-clusters | all-hcp-virt-clusters.yaml | `vendor=OpenShift` + `cloud=KubeVirt` |

### Targeted Placements (Namespace-Scoped)

Defined in `rhacm/targeted-placements/`. These are deployed into specific namespaces rather than the default policy namespace.

| Name | File | Namespace | Label Selectors |
|------|------|-----------|----------------|
| acs-secured-cluster | acs-secured-cluster.yaml | stackrox | `acs-secured-cluster=true\|enabled` |
| acs-secured-xks | acs-secured-xks.yaml | stackrox | External cluster ACS |
| developer-services-rhdh | developer-services-rhdh.yaml | rhdh | `policy.kemo.dev/developer-services=true\|enabled` |
| developer-services-openshift-gitops | developer-services-openshift-gitops.yaml | openshift-gitops | Developer services |
| developer-services-rhbk | developer-services-rhbk.yaml | rhbk | Developer services |
| loki-format-secret | loki-format-secret.yaml | openshift-logging | `rhLoki=true\|enabled` |
| netobserv-loki | netobserv-loki.yaml | netobserv | Network observability Loki |
| community-eso | kube-system_community-eso.yaml | kube-system | Community ESO |
| all-openshift-clusters | open-cluster-management-observability-all-openshift-clusters.yaml | open-cluster-management-observability | All OpenShift clusters |

---

## PolicySets

All PolicySets live in `rhacm/policy-sets/`.

### Global PolicySets

| Name | File | Policies Included |
|------|------|-------------------|
| global-openshift-operators | global-openshift-operators.yaml | operators-gitops-base, operators-logging-base, operators-rh-cert-manager, operators-rhacs, operators-web-terminal, operators-compliance, operators-nmo, operators-coo, operators-oadp, operators-gatekeeper, operators-sscsi |
| global-openshift-config | global-openshift-config.yaml | root-ca-distribution, global-base-namespaces, cluster-info-header, disable-self-provisioner, configure-project-template, audit-logging-config, encrypt-etcd, image-vuln-scanning, enable-multinetworkpolicy, compliance-cis-scan, compliance-e8-scan |
| health-checks | health-checks.yaml | health-clusteroperator, health-clusterversion, health-machineconfigpool, health-node |
| hub-health-checks | hub-health-checks.yaml | health-mc-addons-foo-test, health-mc-addons-gov-pol-frmwk, health-mc-addons-app-mgr, health-mc-addons-mgsvcact, health-mc-addons-search, health-mc-addons-o11y, health-mc-addons-cluster-proxy, health-mc-addons-policy-cntrlr, health-mc-addons-cert-cntrlr, health-mc-addons-wrk-mgr |

### Feature PolicySets

| Name | File | Policies Included |
|------|------|-------------------|
| developer-services | developer-services.yaml | operators-cnpgsql, operators-openshift-builds, operators-pipelines, operators-devspaces, operators-serverless, operators-authorino, operators-rhoai, operators-dev-hub, operators-servicemesh-2, instance-pipelines, instance-dev-hub |
| enhanced-metrics | enhanced-metrics.yaml | operators-power-monitoring, operators-cost-mgmt, instance-power-monitoring, instance-cost-mgmt, operators-net-obsv, instance-netobserv |

### Operator & Instance Bundle PolicySets

| Name | File | Policies Included |
|------|------|-------------------|
| operator-bundle-virt | operator-bundle-virt.yaml | operators-descheduler, operators-far, operators-mtv-base, operators-nfd, operators-nmo, operators-nmstate, operators-node-healthcheck, operators-oadp, operators-snr, operators-virtualization |
| instance-bundle-virt | instance-bundle-virt.yaml | instance-nfd, instance-nmstate, instance-mtv, instance-virtualization, instance-descheduler, instance-far |
| operator-bundle-nvidia-gpu | operator-bundle-nvidia.yaml | operators-nvidia-gpu, operators-nfd |
| instance-bundle-nvidia-gpu | instance-bundle-nvidia.yaml | instance-nfd, instance-nvidia-gpu |
| operator-bundle-odf | operator-bundle-odf.yaml | operators-lso, operators-odf |
| instance-bundle-odf | instance-bundle-odf-lso-bmh.yaml | instance-lso |

### On-Premises PolicySets

| Name | File | Policies Included |
|------|------|-------------------|
| onprem-openshift-operators | onprem-openshift-operators.yaml | operators-metallb, operators-nmstate, instance-metallb, instance-nmstate |
| onprem-openshift-config | onprem-openshift-config.yaml | machine-configuration, kubelet-configuration, label-nodes, configure-idp, configure-ingress-certs, remove-kubeadmin, openshift-samples-config |

### HCP PolicySets

| Name | File | Policies Included |
|------|------|-------------------|
| global-hcp-virt-openshift-operators | global-hcp-virt-openshift-operators.yaml | operators-gitops-base, operators-logging-base, operators-rh-cert-manager, operators-rhacs, operators-metallb, operators-web-terminal, operators-compliance, operators-nmo, operators-oadp, operators-coo, operators-sscsi, instance-metallb |
| global-hcp-virt-openshift-config | global-hcp-virt-openshift-config.yaml | cluster-info-header, disable-self-provisioner, image-vuln-scanning, enable-multinetworkpolicy |

---

## PolicyGenerators

All PolicyGenerators live in `rhacm/policy-generators/`.

| Name | Directory | Generated Policy | Consolidate | Remediation |
|------|-----------|-----------------|-------------|-------------|
| machine-configuration | machineconfigs/ | machine-configuration | false | enforce |
| kubelet-configuration | kubeletconfig/ | kubelet-configuration | false | enforce |
| conruntime-configuration | containerruntimeconfig/ | conruntime-configuration | false | enforce |
| configure-idp-login-screen | matrix-red-login/ | configure-idp-login-screen | false | enforce |

All generators use namespace `open-cluster-management-policies` and do not generate automatic placement.

---

## PlacementBindings

All core bindings live in `rhacm/placement-bindings/`.

### Global Bindings

| Name | File | Placement | Bound Subjects |
|------|------|-----------|---------------|
| global | global.yaml | global | failing-inform (Policy) |
| all-openshift-clusters | all-openshift-clusters.yaml | all-openshift-clusters | health-checks (PolicySet), global-openshift-config (PolicySet), global-openshift-operators (PolicySet) |
| hub-cluster | hub-cluster.yaml | hub-cluster | hub-health-checks (PolicySet), hcp-bmh-acm-infra-creds (Policy), enable-internal-registry (Policy), operators-coo (Policy), operators-aap-base (Policy), operators-rhbk-base (Policy), operators-talm (Policy), instance-acs-central (Policy), instance-aap-2.6 (Policy), instance-rhbk-26.4 (Policy) |
| onprem-openshift-clusters | onprem-openshift-clusters.yaml | onprem-openshift-clusters | onprem-openshift-operators (PolicySet), onprem-openshift-config (PolicySet) |

### Feature Bindings

| Name | File | Placement | Bound Subjects |
|------|------|-----------|---------------|
| acs-central | acs.yaml | acs-central | instance-acs-central (PolicySet), instance-acs-secured-cluster (PolicySet) |
| developer-services | developer-services.yaml | developer-services | developer-services (PolicySet), operators-mtc-base (Policy) |
| virtualization | virtualization.yaml | virtualization | operator-bundle-virt (PolicySet), instance-bundle-virt (PolicySet) |
| enhanced-metrics | enhanced-metrics.yaml | enhanced-metrics | enhanced-metrics (PolicySet) |
| nvidia-gpu | nvidia-gpu.yaml | nvidia-gpu | operator-bundle-nvidia-gpu (PolicySet), instance-bundle-nvidia-gpu (PolicySet) |
| bmh-lso-odf | bmh-lso-odf.yaml | bmh-lso-odf | operator-bundle-odf (PolicySet), instance-bundle-odf (PolicySet) |
| servicemesh2 | servicemesh.yaml | servicemesh2 | operators-servicemesh-2 (Policy), instance-servicemesh-2 (Policy) |
| servicemesh3 | servicemesh.yaml | servicemesh3 | operators-servicemesh-3 (Policy), instance-servicemesh-3 (Policy) |
| kyverno-policies | kyverno-policies.yaml | kyverno-policies | kyverno-policies (Policy) |
| community-eso | community-eso.yaml | community-eso | operators-community-eso (Policy), instance-community-eso (Policy) |
| hub-developer-services | hub-developer-services.yaml | hub-developer-services | hub-dev-svcs (ApplicationSet) |

### Version-Specific Bindings

| Name | File | Placement | Bound Subjects |
|------|------|-----------|---------------|
| developer-services-4.19 | developer-services.yaml | developer-services-4.19 | operators-4.19-mtc-1.8 (Policy) |
| virtualization-4.19 | virtualization.yaml | virtualization-4.19 | operators-4.19-mtv-2.9 (Policy) |
| virtualization-4.20 | virtualization.yaml | virtualization-4.20 | operators-4.20-mtv-2.10 (Policy), gitops-1.18 (Policy) |
| rh-loki-4.19 | rh-loki.yaml | rh-loki-4.19 | operators-4.19-logging-6.3 (Policy), instance-logging-6.3 (Policy) |
| hub-4.19-clusters | hub-4.19-clusters.yaml | hub-4.19-clusters | *(reserved, no subjects yet)* |
| hub-4.20-clusters | hub-4.20-clusters.yaml | hub-4.20-clusters | *(reserved, no subjects yet)* |
| openshift-4.19-clusters | openshift-4.19-clusters.yaml | openshift-4.19-clusters | *(reserved, no subjects yet)* |
| openshift-4.20-clusters | openshift-4.20-clusters.yaml | openshift-4.20-clusters | *(reserved, no subjects yet)* |

### HCP Bindings

| Name | File | Placement | Bound Subjects |
|------|------|-----------|---------------|
| hcp-kubevirt | hcp-kubevirt.yaml | hcp-kubevirt | global-hcp-virt-openshift-operators (PolicySet), global-hcp-virt-openshift-config (PolicySet) |
| hcp-inception | hcp-inception.yaml | hcp-inception | global-openshift-config (PolicySet), global-openshift-operators (PolicySet) |
| hcp-baremetal | hcp-baremetal.yaml | hcp-baremetal | global-openshift-config (PolicySet), global-openshift-operators (PolicySet) |
| hcp-services | hcp-services.yaml | hcp-services | instance-bundle-odf (PolicySet) |
| all-hcp-virt-clusters | all-hcp-virt-clusters.yaml | all-hcp-virt-clusters | *(reserved, no subjects yet)* |

### Targeted Bindings

Defined in `rhacm/targeted-placements/`, deployed into specific namespaces.

| Name | File | Namespace | Placement | Bound Subjects |
|------|------|-----------|-----------|---------------|
| acs-secured-cluster | acs-secured-cluster.yaml | stackrox | acs-secured-cluster | acs-secured-cluster (Policy) |
| acs-secured-xks | acs-secured-xks.yaml | stackrox | acs-secured-xks | acs-secured-xks (Policy) |
| developer-services-rhdh | developer-services-rhdh.yaml | rhdh | developer-services | rhdh-rhdh-secrets (Policy) |
| developer-services-openshift-gitops | developer-services-openshift-gitops.yaml | openshift-gitops | developer-services | argocd-rhdh-secrets (Policy) |
| developer-services-rhbk | developer-services-rhbk.yaml | rhbk | developer-services | rhbk-rhdh-secrets (Policy) |
| loki-format-secret | loki-format-secret.yaml | openshift-logging | loki-format-secret | loki-format-secret (Policy) |
| netobserv-loki | netobserv-loki.yaml | netobserv | netobserv-loki | netobserv-loki-format-secret (Policy) |
| all-openshift-clusters | open-cluster-management-observability-all-openshift-clusters.yaml | open-cluster-management-observability | all-openshift-clusters | configure-monitoring (Policy) |
| community-eso | kube-system_community-eso.yaml | kube-system | community-eso | creds-copy-vault-userpass (Policy) |
