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
