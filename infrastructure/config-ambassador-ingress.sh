#!/bin/sh
set -o errexit

# add ambassador ingress controller
kubectl apply -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-crds.yaml
kubectl apply -n ambassador -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-kind.yaml
kubectl wait --timeout=180s -n ambassador --for=condition=deployed ambassadorinstallations/ambassador

# create ingress class of ambassador and make it the default for any created ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: ambassador
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: getambassador.io/ingress-controller
EOF
