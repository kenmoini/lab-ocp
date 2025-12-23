#!/bin/bash
#
# Copyright (c) 2020-2024 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

INSTALLED_TOOLS="Command |Version |Name"

function append_ver() {
  INSTALLED_TOOLS="$INSTALLED_TOOLS\n$1"
}

OC_VER=$(oc version --client -o json | jq -r '.clientVersion.gitVersion' | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
append_ver "oc       |${OC_VER#v}        |OpenShift CLI"

KUBECTL_VER=$(kubectl version --client -o json | jq -r '.clientVersion.gitVersion' | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
append_ver "kubectl  |${KUBECTL_VER#v}   |Kubernetes CLI"

if command -v kustomize &>/dev/null; then
  KUSTOMIZE_VER=$(kustomize version | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "kustomize|${KUSTOMIZE_VER#v} |Kustomize CLI"
else
  KUSTOMIZE_VER=$(kubectl version --client -o json | jq -r '.kustomizeVersion')
  append_ver "kustomize|${KUSTOMIZE_VER#v} |Kustomize CLI (built-in to kubectl)"
fi

if command -v helm &>/dev/null; then
  HELM_VER=$(helm version --short --template '{{.Version}}' 2>/dev/null | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "helm     |${HELM_VER#v}      |Helm CLI"
fi

if command -v kn &>/dev/null; then
  KN_VER=$(kn version -o json | jq -r '.Version')
  append_ver "kn       |${KN_VER#v}        |KNative CLI"
fi

if command -v tkn &>/dev/null; then
  TKN_VER=$(tkn version --component client)
  append_ver "tkn      |${TKN_VER#v}       |Tekton CLI"
fi

if command -v subctl &>/dev/null; then
  SUBMARINER_VER=$(subctl version | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+|release-[0-9]+\.[0-9]+')
  append_ver "subctl   |${SUBMARINER_VER#v}|Submariner CLI"
fi

if command -v virtctl &>/dev/null; then
  KUBEVIRT_VER=$(virtctl version --client | grep -Eo 'GitVersion:"[^"]+"' | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "virtctl  |${KUBEVIRT_VER#v}  |KubeVirt CLI"
fi

if command -v rhoas &>/dev/null; then
  RHOAS_VER=$(rhoas version | grep -Eo 'v?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "rhoas    |${RHOAS_VER#v}     |Red Hat OpenShift Application Services CLI"
fi

if command -v ansible &>/dev/null; then
  ANSIBLE_VER=$(ansible --version | grep -Eo 'core ?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "ansible    |${ANSIBLE_VER#core }     |Ansible Core CLI"
fi

if command -v operator-sdk &>/dev/null; then
  OPERATOR_SDK_VER=$(operator-sdk version | grep -oP 'operator-sdk version: "\K.*?(?="|$)')
  append_ver "operator-sdk    |${OPERATOR_SDK_VER}     |Operator SDK CLI"
fi

if command -v opm &>/dev/null; then
  OPM_VER=$(opm version | grep -oP 'OpmVersion:"\K.*?(?="|$)')
  append_ver "opm    |${OPM_VER}     |opm"
fi

if command -v ocm &>/dev/null; then
  OCM_VER=$(ocm version)
  append_ver "ocm    |${OCM_VER}     |OpenShift Cluster Manager CLI (ocm)"
fi

if command -v rosa &>/dev/null; then
  ROSA_VER=$(rosa version --client | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+|release-[0-9]+\.[0-9]+')
  append_ver "rosa    |${ROSA_VER}     |Red Hat OpenShift Serivce on AWS CLI (rosa)"
fi

if command -v odo &>/dev/null; then
  ODO_VER=$(odo version --client | grep -oP 'odo v\K.*?(?= |$)')
  append_ver "odo    |${ODO_VER}     |OpenShift Developer Tooling (odo)"
fi

if command -v istioctl &>/dev/null; then
  ISTIOCTL_VER=$(istioctl version --short --remote=false -o json | jq -r '.clientVersion.version')
  append_ver "istioctl    |${ISTIOCTL_VER}     |Istio CLI (istioctl)"
fi

if command -v butane &>/dev/null; then
  BUTANE_VER=$(butane --version | grep -oP 'Butane ?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "butane    |${BUTANE_VER#Butane }     |Butane"
fi

if command -v roxctl &>/dev/null; then
  ROXCTL_VER=$(roxctl version)
  append_ver "roxctl    |${ROXCTL_VER}     |Red Hat OpenShift Advanced Cluster Security CLI (roxctl)"
fi

if command -v k9s &>/dev/null; then
  K9S_VER=$(k9s version --short | grep Version | grep -Eo '?[0-9]+\.[0-9]+\.[0-9]+')
  append_ver "k9s    |${K9S_VER}     |K9s CLI"
fi

JQ_VER=$(jq --version)
JQ_VER=${JQ_VER#jq-}
append_ver "jq       |${JQ_VER#v}        |jq"

echo -e "$INSTALLED_TOOLS" | column -t -s '|'