#!/bin/sh

# We need to get the DO access token. This is stored in a config file
ACCESS_TOKEN=$(docker run --rm -v $HOME/.config/doctl:/workdir mikefarah/yq yq r config.yaml access-token)
SERVER_NAME=telescope

# init to setup DO plugins :)
terraform init

# terraform apply - new terraform apply basically runs plan first anyway
terraform apply -var="do_token=$ACCESS_TOKEN" -var="server_name=$SERVER_NAME"

IP=$(doctl compute droplet list --output json | jq -r '.[] | select(.name|test("telescope")) | .networks.v4 | .[].ip_address')

echo "Server running at $IP"

# No, I don't really want to use ansible.
echo "Running setup"

scp ./setup.sh root@$IP:/root/setup.sh

ssh -t root@$IP "chmod +x ./setup.sh && ./setup.sh"
