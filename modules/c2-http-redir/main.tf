terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

resource "digitalocean_droplet" "c2-http-redir" { #creating a droplet for http-redirector
    image = "${var.type}"
    name = var.redir_name
    region = "${var.region}"
    size = "${var.size}"
    private_networking = true
    ssh_keys = var.ssh_key
    #ssh_keys = ["${digitalocean_ssh_key.ssh_key.fingerprint}"] 

  connection {
      host = self.ipv4_address
      user = "root"
      type = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      timeout = "2m"
  }

  provisioner "remote-exec" { #setting up http-redir using socat
    inline = [
      "export PATH=$PATH:/usr/bin",
      "wget http://archive.ubuntu.com/ubuntu/pool/main/s/socat/socat_1.7.3.2-2ubuntu2_amd64.deb",
      "dpkg -i /root/socat_1.7.3.2-2ubuntu2_amd64.deb",
      "tmux new-session -d -s socat-redir socat TCP4-LISTEN:80,fork TCP4:${var.c2_ip}:80"
    ]
  }
}