#!/usr/bin/env bash

echo "LOG $(date) ------------------------------------------------------------------------"
echo "LOG $(date) -- install klaeff cluster"
echo "LOG $(date) ------------------------------------------------------------------------"

if [ "$(kind get clusters)" != "klaeff-cluster" ]; then

cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: klaeff-cluster
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 8083
    protocol: TCP
EOF

else
echo "LOG $(date) cluster is already running..."
fi

kind get clusters
kind get nodes -n klaeff-cluster
kind get  kubeconfig -n klaeff-cluster > ./gen/kubeconfig.yml