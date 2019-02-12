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
export MY_PROJECT="workaround-3"
export AWS_ACCESS_KEY_ID="AKIAIXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#

export AWS_DEFAULT_REGION="us-east-2"
export AWS_DEFAULT_OUTPUT="JSON"


INSTANCE_PROFILE_1=arn:aws:iam::323532686453:instance-profile/kops-custom-node-role
INSTANCE_PROFILE_2=arn:aws:iam::323532686453:instance-profile/kops-custom-master-role


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
  -e INSTANCE_PROFILE_1=${INSTANCE_PROFILE_1} \
  -e INSTANCE_PROFILE_2=${INSTANCE_PROFILE_2} \
  aws-k8s:1
}
