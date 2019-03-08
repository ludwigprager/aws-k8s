#!/bin/bash

set -e

VOL_ID=$(./get-volume-id.py)

# targetPort: port the container listens on 
# port: accessible from other containers


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

# test dns:
# kubectl exec -ti busybox -- nslookup registry.default.svc.cluster.local

# test open port:
# kubectl exec -ti busybox -- nc -zv registry.default.svc.cluster.local 5001

