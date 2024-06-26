# Name of the tunnel you want to run
tunnel: ${cloudflared_tunnel_id}
credentials-file: /etc/cloudflared/creds/credentials.json
# Serves the metrics server under /metrics and the readiness server under /ready
metrics: 0.0.0.0:2000
# Autoupdates applied in a k8s pod will be lost when the pod is removed or restarted, so
# autoupdate doesn't make sense in Kubernetes. However, outside of Kubernetes, we strongly
# recommend using autoupdate.
no-autoupdate: true
# The ingress block tells cloudflared which local service to route incoming
# requests to. For more about ingress rules, see
# https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/ingress
#
# Remember, these rules route traffic from cloudflared to a local service. To route traffic
# from the internet to cloudflared, run cloudflared tunnel route dns <tunnel> <hostname>.
# E.g. cloudflared tunnel route dns example-tunnel tunnel.example.com.
ingress:
%{ for rule in jsondecode(ingress) ~}
%{ if lookup(rule, "hostname", null) != null  ~}
  - hostname: ${rule.hostname}
%{ endif ~}
%{ if lookup(rule, "path", null) != null  ~}
    path: ${rule.path}
%{ endif ~}
%{ if lookup(rule, "service", null) != null  ~}
    service: ${rule.service}
%{ endif ~}  
%{ endfor ~}
  - service: http_status:404