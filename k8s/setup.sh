#!/bin/sh
set -o errexit

# pre-requisite: please make sure you have a cluster ready.
# you can use either one of the ../infrastructure/ shell scripts to create a local Kind cluster.

# point this to where you extracted the gateway installer for k8s
installer_dir='/Users/haythamm/presentations/scg-4k8s/installer-1.0.0'

# to tag and push to registry. localhost:5000 is for a local registry installed with Kind
${installer_dir}/scripts/relocate-images.sh localhost:5000

# install the gateway operator & CRD and other K8s components
${installer_dir}/scripts/install-spring-cloud-gateway.sh

# assumed you have the images ready and you want to push
docker push localhost:5000/frontend-service
docker push localhost:5000/backend-service

# install gateway, routs, mappings, services and ingress
kubectl apply -f ./k8s/install-gateway.yml
kubectl apply -f ./k8s/install-gateway-routes-config.yml
kubectl apply -f ./k8s/install-gateway-mappings.yml
kubectl apply -f ./k8s/install-services.yml
kubectl apply -f ./k8s/install-ingress.yml
