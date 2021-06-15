resource "digitalocean_ssh_key" "ssh_key" {
  name       = "SSH"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "covenant-c2" { #create a new droplet which will be our main c2 server
    image = "ubuntu-18-04-x64"
    name = "covenant-c2"
    region = "blr1" #DO Region
    size = "s-2vcpu-2gb"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.ssh_key.fingerprint}"]

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

resource "digitalocean_droplet" "covenant-c2-redir" { #creating a droplet for http-redirector
    image = "ubuntu-18-04-x64"
    name = "covenant-c2-redir"
    region = "blr1"
    size = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.ssh_key.fingerprint}"] 

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
      "tmux new-session -d -s socat-redir socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.covenant-c2.ipv4_address}:80"
    ]
  }
}

