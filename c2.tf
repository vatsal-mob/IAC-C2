resource "digitalocean_ssh_key" "win_mob1" {
  name       = "SSH"
  public_key = "${file("C:/Users/MOB/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "covenant-c2" {
    image = "ubuntu-18-04-x64"
    name = "covenant-c2"
    region = "blr1"
    size = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.win_mob1.fingerprint}"]

connection {
      host = self.ipv4_address
      user = "root"
      type = "ssh"
      private_key = "${file("C:/Users/MOB/.ssh/id_rsa")}"
      timeout = "2m"
}

 provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install docker
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo apt install -y git",
      "git clone --recurse-submodules https://github.com/cobbr/Covenant",
      "docker build -t covenant /root/Covenant/Covenant/",
      "docker run -d -p 7443:7443 -p 80:80 -p 443:443 --name covenant -v /root/Covenant/Covenant/Data/:/app/Data covenant"
    ]
  }
}

resource "digitalocean_firewall" "covenant-c2" {
    name = "portforwarding"

  droplet_ids = ["${digitalocean_droplet.covenant-c2.id}"]

  inbound_rule {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "7443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
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