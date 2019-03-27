#!/bin/bash

# https://github.com/kubernetes/kops/blob/master/docs/iam_roles.md
# https://krish512.com/setup-kubernetes-cluster-kops-aws/
# 

set -e
#set -x

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

# -- bastion for ssh to master (needs '--topology private')
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

kops update cluster \
  --lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges \
  --yes \
  --out=./ --target=terraform


terraform init
terraform graph | dot -Tsvg > graph.svg
terraform apply -auto-approve

# now once more because of https://github.com/kubernetes/kops/issues/2990
kops update cluster \
  --lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges \
  --yes \
  --out=./ --target=terraform
kops export kubecfg
terraform apply -auto-approve

# see
# https://www.bountysource.com/issues/47372764-cannot-use-terraform-and-gossip-based-cluster-at-the-same-time
# for workaround
#kops rolling-update cluster --cloudonly --force --master-interval=1s --node-interval=1s --yes
#kops rolling-update cluster --cloudonly --force --yes


## Wait until all nodes come back online before marking complete
#until kops validate cluster > /dev/null
#do
#  echo "\033[1;93mWaiting until cluster comes back online\033[0m"
#  sleep 5
#done
#
#echo "\033[1;92mCluster Creation Complete!\033[0m"



#echo wait some time before validating cluster with command:
#echo
#echo kops validate cluster

#echo
# https://github.com/kubernetes/kops/blob/master/docs/examples/kops-tests-private-net-bastion-host.md#adding-a-bastion-host-to-our-cluster
#echo kops create instancegroup bastions --role Bastion --subnet utility-${ZONE1}a 

