output "redir-dns" {
  value = cloudflare_record.http-redir.name
}