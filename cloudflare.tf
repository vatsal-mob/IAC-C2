resource "cloudflare_record" "covenant-main" { #creating record for your main c2
  zone_id = "${var.cloudflare_zone}"
  name   = "covenant-main"  #this will create something like covenant-main.domain.xyz
  value  = "${digitalocean_droplet.covenant-c2.ipv4_address}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "ads" { #creating record for your http-redir
  zone_id = "${var.cloudflare_zone}"
  name   = "ads" #this will create something like ads.domain.xyz
  value  = "${digitalocean_droplet.covenant-c2-redir.ipv4_address}"
  type   = "A"
  ttl    = 3600
}