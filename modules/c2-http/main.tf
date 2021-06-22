terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.9.0"
    }
  }
}

data "template_file" "script" {
  template = file("modules/c2-http/covenant.sh")
}

resource "digitalocean_droplet" "covenant-c2" { #create a new droplet which will be our main c2 server
    image = "${var.type}"
    name = "covenant-c2" #name in DO
    region = "${var.region}"
    size = "${var.size}"
    private_networking = true
    ssh_keys = var.ssh_key
    user_data = data.template_file.script.rendered
    lifecycle {
      create_before_destroy = true
    }
}

resource "digitalocean_record" "c2" {
  domain = "myc2domain.xyz"
  type   = "A"
  name   = "cov"
  value  = "${digitalocean_droplet.covenant-c2.ipv4_address}"
}

resource "digitalocean_certificate" "cert" {
  name    = "le-terraform-example"
  type    = "lets_encrypt"
  domains = ["${digitalocean_record.c2.name}.${digitalocean_record.c2.domain}"]
}