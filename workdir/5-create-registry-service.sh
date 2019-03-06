#!/bin/bash

set -e

VOL_ID=$(./get-volume-id.py)


cat <<EOF | kubectl create -f -
---
apiVersion: v1
kind: Service
metadata:
  name: registry
  labels:
    name: registry
spec:
  ports:
  - port: 5001
    targetPort: 5000
    nodePort: 30500
  selector:
    name: registry
  type: NodePort
EOF
