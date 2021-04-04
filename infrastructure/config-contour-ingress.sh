#!/bin/sh
set -o errexit

# add contour ingress controller
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

# envy daemon on worker nodes only
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"}}}}}'

# create ingress class of contour and make it the default for any created ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: contour
  annotations:
    "ingressclass.kubernetes.io/is-default-class": "true"
spec:
  controller: projectcontour.io/contour
EOF
