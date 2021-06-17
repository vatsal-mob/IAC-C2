variable "c2_ip" {
  type = string
}

variable "size" {
	type    = string
}

variable "region" {
	type    = string
}

variable "type" {
	type    = string
}

variable "ssh_key" {
  description = "SSH-KEY"
}

variable "redir_name" {
	type = string
  description = "c2-name"
}

variable "cin" {
	type = string
	description = "count-index"
}