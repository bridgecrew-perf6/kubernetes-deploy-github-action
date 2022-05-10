#!/bin/bash
set -e

echo $ARTIFACT_KUBERNETES_CLUSTER  > data.json

CERTIFICATE_AUTHORITY_DATA=$(jq '.authentication.cluster."certificate-authority-data"' data.json | sed s/\"//g)
CLUSTER_SERVER=$(jq '.authentication.cluster.server' data.json | sed s/\"//g)
TOKEN=$(jq '.authentication.user.token' data.json | sed s/\"//g)

sed "s/<certificate-authority-data>/${CERTIFICATE_AUTHORITY_DATA}/" kube-config-template > kube-config.tmp-0
sed "s|<cluster-server>|${CLUSTER_SERVER}|" kube-config.tmp-0 > kube-config.tmp-1
sed "s/<user-token>/${TOKEN}/" kube-config.tmp-1 > kube-config

rm kube-config.tmp-0 kube-config.tmp-1
KUBE_CONFIG_PATH=$(PWD)/kube-config

# outout the path to the kubeconfig file so downstream steps can use it.
echo "::set-output name=kube_config::${KUBE_CONFIG_PATH}"
