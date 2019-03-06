#!/bin/bash

set -e

VOL_ID=$(./get-volume-id.py)


cat <<EOF | kubectl create -f -
---
apiVersion: v1
kind: Pod
metadata:
  name: registry
spec:
  containers:
  - image: registry:2
    name: registry
    volumeMounts:
    - mountPath: /var/lib/registry
      name: images
  volumes:
  - name: images
    awsElasticBlockStore:
      volumeID: ${VOL_ID}
      fsType: ext4
EOF
