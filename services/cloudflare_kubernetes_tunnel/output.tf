output "id" {
  value = cloudflare_tunnel.current.id
}

output "cname" {
  value = cloudflare_tunnel.current.cname
}

output "tunnel_token" {
  value = cloudflare_tunnel.current.tunnel_token
  sensitive = true
}