###############################################################################
#  _   _                 _                                                    #
# | | | |               | |                                                   #
# | |_| |_   _  __ _  __| | ___  ___                                          #
# |  _  | | | |/ _` |/ _` |/ _ \/ __|                                         #
# | | | | |_| | (_| | (_| |  __/\__ \                                         #
# \_| |_/\__, |\__,_|\__,_|\___||___/                                         #
#         __/ |                                                               #
#        |___/                                                                #
###############################################################################

variable "do_token" {}

variable "region" {
  type = string
	default = "ams3"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

# define the actual cluster
resource "digitalocean_kubernetes_cluster" "hyades" {
	name    = "hyades"
	region  = "${var.region}"
	version = "1.14.4-do.0"
	tags    = [ "hyades" ]

	node_pool {
		name       = "hyades-worker-pool"
		size       = "s-1vcpu-2gb"
		node_count = 2 # two is fineeeee
	}
}

provider "kubernetes" {
	host = "${digitalocean_kubernetes_cluster.hyades.endpoint}"

	client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.hyades.kube_config.0.client_certificate)}"
	client_key             = "${base64decode(digitalocean_kubernetes_cluster.hyades.kube_config.0.client_key)}"
	cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.hyades.kube_config.0.cluster_ca_certificate)}"
}


resource "digitalocean_domain" "hyades" {
  name       = "hyades.cloud"
}
