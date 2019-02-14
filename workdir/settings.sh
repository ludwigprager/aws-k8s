#!/bin/bash

export MY_BUCKET=${MY_PROJECT}

export KOPS_CLUSTER_NAME=k8s.${MY_PROJECT}.k8s.local
export KOPS_STATE_STORE=s3://${MY_BUCKET}

export ZONE1=${REGION}a
export ZONE2=${REGION}b

