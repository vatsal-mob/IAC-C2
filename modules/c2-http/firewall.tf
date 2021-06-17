data "http" "myip" { 
  url = "http://ipv4.icanhazip.com" #getting your current public address in HTTP body
}

resource "digitalocean_firewall" "covenant-c2" {
    name = "portforwarding"

  droplet_ids = ["${digitalocean_droplet.covenant-c2.id}"] #creating firewall rules for main c2 server

  inbound_rule {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["${chomp(data.http.myip.body)}/32"] #allowing SSH only through your public IP 
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "7443"
      source_addresses   = ["${chomp(data.http.myip.body)}/32"] #allowing Covenant GUI only through your public IP 
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
      protocol                = "tcp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
      protocol                = "tcp"
      port_range              = "443"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }
    outbound_rule {
        protocol                = "tcp"
        port_range              = "80"
        destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
  outbound_rule {
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }
}