#!/bin/bash

. ./settings.sh

PORT=8123

#echo URL: https://api.${KOPS_CLUSTER_NAME}/ui

#https://api-k8s-workaround-4-k8s--pu7bqc-1595754191.us-east-1.elb.amazonaws.com/api/v1/


kubectl proxy --port=${PORT} &

#http://localhost:8080/api/v1/namespaces/kube-system/services/kubernetes-dashboard

# v1:

kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.10.1.yaml
kops update cluster  --yes --lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges


# https://stackoverflow.com/questions/39864385/how-to-access-expose-kubernetes-dashb
# https://github.com/kubernetes/dashboard/wiki/Accessing-Dashboard---1.7.X-and-above

echo change the .spec.type to NodePort

sleep 5

kubectl -n kube-system edit service kubernetes-dashboard

echo http://localhost:${PORT}/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

kubectl describe secret
