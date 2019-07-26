#!/bin/sh

ACCESS_TOKEN=$(docker run --rm -v $HOME/.config/doctl:/workdir mikefarah/yq yq r config.yaml access-token)

terraform init
terraform destroy -var="do_token=$ACCESS_TOKEN"
