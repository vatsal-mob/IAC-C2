terraform {
  required_version = ">=1.0"  
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_record" "http-redir" { #creating record for your main c2
  zone_id = var.zone
  name   = "ads-${var.cin}"  #this will create something like covenant-main.domain.xyz
  value  = var.ipv4_redir
  type   = "A"
  ttl    = 3600
}