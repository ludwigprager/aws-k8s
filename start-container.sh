#!/bin/bash


export MY_PROJECT="registry-test-ml"

REGION=eu-west-3


#
# NO CHANGES BEYOND THIS LINE

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t aws-k8s:1 ${DIR}

WORKDIR=${DIR}/workdir/

# forward port 15000 -> 15000 for tagging docker images

docker run --rm -it \
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
  aws-k8s:1
