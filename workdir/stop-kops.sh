#!/bin/bash

. ./settings.sh

kops delete cluster --yes --name ${KOPS_CLUSTER_NAME}
aws s3 rb ${KOPS_STATE_STORE} --force  
pkill -f 'kubectl proxy'
