terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

resource "digitalocean_droplet" "covenant-c2" { #create a new droplet which will be our main c2 server
    image = "${var.type}"
    name = "covenant-c2" #name in DO
    region = "${var.region}"
    size = "${var.size}"
    private_networking = true
    ssh_keys = var.ssh_key
    
  connection {
      host = self.ipv4_address
      user = "root"
      type = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      timeout = "2m"
  }
  provisioner "remote-exec" { #installing covenant on our droplet
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo apt install -y git",
      "git clone --recurse-submodules https://github.com/cobbr/Covenant",
      "docker build -t covenant /root/Covenant/Covenant/",
      "docker run -d -p 7443:7443 -p 80:80 -p 443:443 --name covenant -v /root/Covenant/Covenant/Data/:/app/Data covenant"
    ]
  }
}