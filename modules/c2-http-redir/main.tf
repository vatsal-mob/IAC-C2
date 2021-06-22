terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.9.0"
    }
  }
}

data "template_file" "script" {
  template = file("modules/c2-http-redir/config.sh")
  vars = {
   c2_ip_pass = "${var.c2_ip}"
 }
}

resource "digitalocean_droplet" "c2-http-redir" { #creating a droplet for http-redirector
    image = "${var.type}"
    name = var.redir_name
    region = "${var.region}"
    size = "${var.size}"
    private_networking = true
    ssh_keys = var.ssh_key
    user_data = data.template_file.script.rendered
}

resource "digitalocean_record" "http-redir" {
  domain = "myc2domain.xyz"
  type   = "A"
  name   = "ads-${var.cin}"
  value  = "${digitalocean_droplet.c2-http-redir.ipv4_address}"
}

resource "digitalocean_certificate" "cert" {
  name    = "redir-${var.cin}"
  type    = "lets_encrypt"
  domains = ["${digitalocean_record.http-redir.name}.${digitalocean_record.http-redir.domain}"]
}