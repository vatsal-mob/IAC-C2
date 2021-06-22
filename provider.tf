terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.9.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = "${var.do_token}"
}

/*provider "cloudflare" {
  email = "${var.cloudflare_email}"
  api_key = "${var.cloudflare_token}"
}*/

resource "digitalocean_ssh_key" "ssh_key" {
  name = "ssh_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}