#!/bin/sh

# We need to get the DO access token. This is stored in a config file
ACCESS_TOKEN=$(docker run --rm -v $HOME/.config/doctl:/workdir mikefarah/yq yq r config.yaml access-token)
INGRESS_DOMAIN=hyades.cloud

# init to setup DO plugins :)
terraform init

# terraform apply - new terraform apply basically runs plan first anyway
terraform apply -var="do_token=$ACCESS_TOKEN"

# Download the kubeconfig, it'll automagically update too!
doctl kubernetes cluster kubeconfig save hyades

# At this point we have a domain, a cluster, and we're almost good to go. Buuut
# we need to make sure that the domain points to the load balancer at least!
# Issue being that there is no LB, and k8s likes to manage that itself. 

# create nginx ingress and LB
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

# look! a lb!
kubectl get svc --namespace=ingress-nginx
