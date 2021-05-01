#!/bin/sh
set -o errexit

# add nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# create ingress class of contour and make it the default for any created ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  annotations:
    "ingressclass.kubernetes.io/is-default-class": "true"
spec:
  controller: example.com/ingress-controller
EOF
