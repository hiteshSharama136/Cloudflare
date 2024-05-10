data "cloudflare_zone" "current" {
  name = var.zone_name
}

resource "kubernetes_namespace_v1" "current" {
  count   = (var.create_namespace)?1:0
  metadata {
    name = var.namespace
  }
}

resource "cloudflare_record" "portal" {
  count   =  length(var.hostnames)
  zone_id =  data.cloudflare_zone.current.id
  name    =  var.hostnames[count.index]
  value   =  cloudflare_tunnel.current.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_tunnel" "current" {
  account_id = var.cloudflared_account_id
  name       = "${var.tunnel_name}"
  secret     = base64encode(var.cloudflared_tunnel_secret)

 
}

resource "kubernetes_secret" "tunnel_secret" {

      metadata {
        name      = "cloudflared-tunnel-credentials-${var.zone_name}"
        namespace = var.namespace
      }

      data = {
        "credentials.json" = templatefile("${path.module}/template/tunnel-secret-config.json",{
          cloudflared_account_id  = var.cloudflared_account_id
          cloudflared_tunnel_id  = cloudflare_tunnel.current.id
          cloudflared_tunnel_secret = base64encode(var.cloudflared_tunnel_secret)
        })
      }
}   

resource "kubernetes_config_map" "tunnel_configmap" {
  metadata {
    name = "cloudflared-tunnel-configmap-${var.zone_name}"
    namespace = var.namespace
  }

  data = {
    "config.yaml" = templatefile("${path.module}/template/config.yaml.tpl", {
      cloudflared_tunnel_id = cloudflare_tunnel.current.id,
      ingress = jsonencode(var.ingress_list)
    })
  }
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(templatefile("${path.module}/template/deployment.yaml",{
    zone_name = var.zone_name,
    namespace  = var.namespace
  }))

  depends_on  = [ kubernetes_config_map.tunnel_configmap, kubernetes_secret.tunnel_secret ]
}