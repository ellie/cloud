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

# We can call this from a script, and tell terraform to point the root domain to
# a new LB address

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "hyades_root" {
  domain = "hyades.cloud"
  name   = "hyades.cloud"
  value  = "${var.hyades_lb}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "hyades_cname" {
  domain = "hyades.cloud"
  name   = "*.hyades.cloud"
  value  = "${var.hyades_lb}"
  type   = "CNAME"
  ttl    = 3600
}
