output "c2_main_instance_public_ip" {
  value       = module.c2-http.c2-data.ipv4_address
  description = "The public IP of the main server instance."
}

output "c2_redir_instance_public_ip" {
  value       = module.c2-http-redir.*.c2-data-redir
  description = "The public ip of the main server instance."
}

output "c2_redir_instance_domain" {
  value       = module.dns-redir.*.redir-dns
  description = "The public domain of the main server instance."
}

output "c2_main_instance_domain" {
  value       = module.dns.c2-dns
  description = "The public domain of the main server instance."
}