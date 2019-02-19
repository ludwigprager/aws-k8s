#!/bin/bash

. ./settings.sh

PORT=8123

kubectl proxy --port=${PORT} &

kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.10.1.yaml
kops update cluster  --yes --lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges

# https://stackoverflow.com/questions/39864385/how-to-access-expose-kubernetes-dashb
# https://github.com/kubernetes/dashboard/wiki/Accessing-Dashboard---1.7.X-and-above

kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard


NAME=$(kubectl -n kube-system get secret | grep -o kubernetes-dashboard-token-[a-z,0-9]*)
kubectl -n kube-system describe secret ${NAME} | grep token:

echo
echo http://localhost:${PORT}/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
