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

echo "Setting up nginx ingress and load balancer\n"
# create nginx ingress and LB
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

# look! a lb!
LB_IP=$(kubectl get svc --namespace=ingress-nginx | tail -n 1 | awk '{print $4}')
echo "Setting hyades.cloud to point to $LB_IP\n"

pushd ../dns && terraform init && terraform apply -var="hyades_lb=$LB_IP" && popd

echo "Installing cert-manager\n"
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.8.1/cert-manager.yaml

echo "Sleeping for 30s to ensure everything is UP\n"
sleep 30

echo "Installing cluster issuer\n"
kubectl apply -f k8s/cluster-issuer.yaml

echo "Installing the echo server\n"
kubectl apply -f k8s/echoserver.yaml

echo "Installing the ingress resource\n"
kubectl apply -f k8s/ingress.yaml