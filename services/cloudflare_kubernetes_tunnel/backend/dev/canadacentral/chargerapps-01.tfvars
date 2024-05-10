location = ""
resource_name = ""
 
tags = {
    "Env": "Dev"
    "App": "",
    "TechContact": ""
}

environment = "Dev"
instance_number = "01"

zone_name = ""  //Provide domain name which is active in cloudflared
tunnel_name=""
aks_resource_group_name = ""  
aks_name = ""
cloudflared_account_id = ""
cloudflared_tunnel_secret = ""

create_namespace=false
namespace = "apps"

hostnames = [
    "xyz"
]

ingress_list = [
    {
        hostname = "xyz.com",
        service = ""
    }

    # put all your hostname and service name as per the requirements
]