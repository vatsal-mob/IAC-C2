terraform {
  required_version = ">=1.0"  
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_record" "covenant-main" { #creating record for your main c2
  zone_id = var.zone
  name   = "cov"  #this will create something like cov.domain.xyz
  value  = var.ipv4
  type   = "A"
  ttl    = 3600
}