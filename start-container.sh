#!/bin/bash

export AWS_ACCESS_KEY_ID="AKIAIXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

INSTANCE_PROFILE_NODE=arn:aws:iam::xxxxxxxxxxxx:instance-profile/<your node instance profile name>
INSTANCE_PROFILE_MASTER=arn:aws:iam::xxxxxxxxxxxx:instance-profile/<your master instance profile name>

export MY_PROJECT="CHOOSE-UNIQUE-BUCKET-NAME"

#
# NO CHANGES BEYOND THIS LINE

export AWS_DEFAULT_REGION="us-east-2"
export AWS_DEFAULT_OUTPUT="JSON"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t aws-k8s:1 ${DIR}

WORKDIR=${DIR}/workdir/

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