variable "do_token" {}

variable "region" {
  type = string
	default = "ams3"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "telescope" {
  image  = "ubuntu-19-04-x64"
  name = "${var.server_name}"
  region = "ams3"
  size   = "s-1vcpu-1gb"
	ipv6=true
	backups=true
	monitoring=true
	ssh_keys=[ 25013836 ]
}
