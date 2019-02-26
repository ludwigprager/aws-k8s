#!/bin/bash

# https://github.com/kubernetes/kops/blob/master/docs/iam_roles.md
# https://krish512.com/setup-kubernetes-cluster-kops-aws/
# 

set -e

. ./settings.sh


aws s3api create-bucket \
  --bucket ${MY_BUCKET} \
  --region ${REGION} \
  --create-bucket-configuration LocationConstraint=${REGION}


SSH=~/.ssh/

# generate ssh key
if [ ! -f ${SSH}/id_rsa ]; then
  ssh-keygen -b 2048 -t rsa -f ${SSH}/id_rsa -q -N ""
fi

kops create cluster \
  --zones ${ZONE1} \
  --master-size t2.medium \
  --master-count 1 \
  --node-size t2.medium \
  --node-count 1 \
  --networking calico \
  --topology private \
  || true


kops create secret \
  sshpublickey admin \
  -i ${SSH}/id_rsa.pub

kops describe secret  admin

kops get ig

# fetch bucket
aws s3 sync --delete ${KOPS_STATE_STORE} bucket/

# edit cluster in the bucket
yq w -i bucket/${KOPS_CLUSTER_NAME}/instancegroup/master-${ZONE1} \
  spec.iam.profile ${INSTANCE_PROFILE_NODE}
yq w -i bucket/${KOPS_CLUSTER_NAME}/instancegroup/nodes \
  spec.iam.profile ${INSTANCE_PROFILE_MASTER}

# update bucket
aws s3 sync --delete bucket/ ${KOPS_STATE_STORE}


kops update cluster  --yes --lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges

echo wait some time before validating cluster with command:
echo
echo kops validate cluster
