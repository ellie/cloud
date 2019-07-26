#!/bin/sh

# We need to get the DO access token. This is stored in a config file
ACCESS_TOKEN=$(docker run --rm -v $HOME/.config/doctl:/workdir mikefarah/yq yq r config.yaml access-token)

# init to setup DO plugins :)
terraform init

# terraform apply - new terraform apply basically runs plan first anyway
terraform apply -var="do_token=$ACCESS_TOKEN"

# Download the kubeconfig, it'll automagically update too!
doctl kubernetes cluster kubeconfig save hyades

# At this point we have a domain, a cluster, and we're almost good to go. Buuut
# we need to make sure that the domain points to the load balancer at least!
# Issue being that there is no LB, and k8s likes to manage that itself. 
# So, apply the LB config...
