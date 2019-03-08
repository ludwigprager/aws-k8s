#!/bin/bash

set -e

VOL_ID=$(./get-volume-id.py)

# containerPort: port the container listen on

cat <<EOF | kubectl create -f -
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: registry
spec:
  replicas: 1
  template:
    metadata:
      labels:
        name: registry
    spec:
      containers:
      - resources:
        name: registry
        image: registry:2
        ports:
        - name: registry-port
          containerPort: 5000
        volumeMounts:
        - mountPath: /var/lib/registry
          name: images
      volumes:
      - name: images
        awsElasticBlockStore:
          volumeID: ${VOL_ID}
          fsType: ext4
EOF

# forward localhost:15000 to registry-pod:5000
: '
# get pod name
POD=$( kubectl get pod -l name=registry | sed -n 2p | awk '{print $1}' )
kubectl port-forward ${POD} 15000:5000&
# test with curl
curl localhost:15000

# then push an image (issue command on the host of this container):
docker commit 2379df96c710 test-image
docker tag test-image localhost:15000/ludwigprager/test-image
docker push localhost:15000/ludwigprager/test-image
'

