variable "cloudflare_zone" {
  type = string
  description = "Your Cloudflare Zone ID"
}

variable "cloudflare_token" {
  type = string
  description = "Your Cloudflare Global API Token"
}

variable "cloudflare_email" {
  type = string
  description = "Your Cloudflare Email ID"
}

variable "do_token" {
  type = string
  description = "Your Digital Ocean Token"
}

variable "instance_size" {
	type    = string
	default = "s-1vcpu-1gb"
}

variable "instance_region" {
	type    = string
	default = "blr1"
}

variable "instance_type" {
	type    = string
	default = "ubuntu-18-04-x64"
}

variable "cin" {
  type = string
  default = "1"
}