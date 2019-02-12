#!/bin/bash

function k8s() {

	WORKDIR=$1

if [[ -z $WORKDIR  ]]; then
	echo "missing workdir"
	echo "example:"
	echo "k8s ~/work/k8s/terraform-gossip/"
	return
fi

# 
export AWS_ACCESS_KEY_ID="AKIAIXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

INSTANCE_PROFILE_NODE=arn:aws:iam::xxxxxxxxxxxx:instance-profile/kops-custom-node-role
INSTANCE_PROFILE_MASTER=arn:aws:iam::xxxxxxxxxxxx:instance-profile/kops-custom-master-role

export MY_PROJECT="CHOOSE-UNIQUE-BUCKET-NAME"
#

export AWS_DEFAULT_REGION="us-east-2"
export AWS_DEFAULT_OUTPUT="JSON"




DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t aws-k8s:1 ${DIR}

docker run --rm -it \
  -v ${DIR}/ssh:/root/.ssh:ro \
  -v ${DIR}/kube:/root/.kube:rw \
  -v ${DIR}/helm:/root/.helm:rw \
  -v ${WORKDIR}/:/workdir \
  -w /workdir \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -e MY_PROJECT=${MY_PROJECT} \
  -e INSTANCE_PROFILE_NODE=${INSTANCE_PROFILE_NODE} \
  -e INSTANCE_PROFILE_MASTER=${INSTANCE_PROFILE_MASTER} \
  aws-k8s:1
}
