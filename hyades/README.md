# hyades

The terraform needed to deploy a kubernetes cluster on DigitalOcean, currently
used for a bunch of my side projects :) See `telescope` for the dev server.

`build-0.sh` should be ran first, and will create the cloud resources necessary,
as well as setup nginx ingress + a load balancer on the cluster.

`build-1.sh` should then be ran, with the output IP of the first provided. For
instance, `./build-1.sh 192.168.1.1`. This will set the DNS record for
`hyades.cloud` to point to the new load balancer, and then go on to setup
a letsencrypt certificate issuer.

Once done, there isn't anything left to do but `kubectl apply -f k8s/apps` to
install and setup all the applications :)
