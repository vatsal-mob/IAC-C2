terraform {
  required_version = ">=1.0"
}

module "c2-http" {
  source = "./modules/c2-http" 
  size = var.instance_size
  region = var.instance_region
  type = var.instance_type
  ssh_key = ["${digitalocean_ssh_key.ssh_key.fingerprint}"]
}

module "c2-http-redir" {
  source = "./modules/c2-http-redir"
  redir_name = "http-c2-redir-${count.index+1}" # http-c2-redir-1
  c2_ip = module.c2-http.c2-data.ipv4_address # gets public ip address from c2-http
  size = var.instance_size
  region = var.instance_region
  type = var.instance_type
  ssh_key = ["${digitalocean_ssh_key.ssh_key.fingerprint}"]
  cin = "${count.index+1}"  # sending back the current count index value for firewall name
  count = 1
}
/*
module "dns" {
  source = "./modules/c2-dns"
  ipv4 = module.c2-http.c2-data.ipv4_address
  zone = var.cloudflare_zone
}*/

/*
module "dns-redir" {
  source = "./modules/c2-redir-dns"
  ipv4_redir = module.c2-http-redir[count.index].c2-data-redir #get redirector ipv4 address for current count
  zone = var.cloudflare_zone
  cin = "${count.index+1}"
  count = 1
}*/