#!/bin/bash

export COMPDIR=$(pkg-config --variable=completionsdir bash-completion)

kubectl completion bash > $COMPDIR/kubectl
oc completion bash > $COMPDIR/oc

if command -v kustomize &>/dev/null; then
  kustomize completion bash > $COMPDIR/kustomize
fi

if command -v helm &>/dev/null; then
  helm completion bash > $COMPDIR/helm
fi

if command -v kn &>/dev/null; then
  kn completion bash > $COMPDIR/kn
fi

if command -v tkn &>/dev/null; then
  tkn completion bash > $COMPDIR/tkn
fi

if command -v subctl &>/dev/null; then
  subctl completion bash > $COMPDIR/subctl
fi

if command -v virtctl &>/dev/null; then
  virtctl completion bash > $COMPDIR/virtctl
fi

if command -v rhoas &>/dev/null; then
  rhoas completion bash > $COMPDIR/rhoas
fi

if command -v operator-sdk &>/dev/null; then
  operator-sdk completion bash > $COMPDIR/operator-sdk
fi

if command -v opm &>/dev/null; then
  opm completion bash > $COMPDIR/opm
fi

if command -v ocm &>/dev/null; then
  ocm completion bash > $COMPDIR/ocm
fi

if command -v rosa &>/dev/null; then
  rosa completion bash > $COMPDIR/rosa
fi

if command -v odo &>/dev/null; then
  odo completion bash > $COMPDIR/odo
fi

if command -v istioctl &>/dev/null; then
  istioctl completion bash > $COMPDIR/istioctl
fi

if command -v roxctl &>/dev/null; then
  roxctl completion bash > $COMPDIR/roxctl
fi

if command -v k9s &>/dev/null; then
  k9s completion bash > $COMPDIR/k9s
fi
