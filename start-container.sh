#!/bin/bash

export AWS_ACCESS_KEY_ID="AKIAIXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

INSTANCE_PROFILE_NODE=arn:aws:iam::xxxxxxxxxxxx:instance-profile/<your node instance profile name>
INSTANCE_PROFILE_MASTER=arn:aws:iam::xxxxxxxxxxxx:instance-profile/<your master instance profile name>

export MY_PROJECT="CHOOSE-UNIQUE-BUCKET-NAME"

REGION=eu-west-3


#
# NO CHANGES BEYOND THIS LINE

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t ludwigprager/aws-k8s:1 ${DIR}

WORKDIR=${DIR}/workdir/

# forward port 15000 -> 15000 for tagging docker images

docker run --rm -it \
  --user 1000 \
  -v ${DIR}/ssh:/root/.ssh:rw \
  -v ${DIR}/kube:/root/.kube:rw \
  -v ${DIR}/helm:/root/.helm:rw \
  -v ${WORKDIR}/:/workdir \
  -w /workdir \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -e MY_PROJECT=${MY_PROJECT} \
  -e INSTANCE_PROFILE_NODE=${INSTANCE_PROFILE_NODE} \
  -e INSTANCE_PROFILE_MASTER=${INSTANCE_PROFILE_MASTER} \
  -e REGION=${REGION} \
  -p 15000:15000/tcp \
  --network host \
  ludwigprager/aws-k8s:1
