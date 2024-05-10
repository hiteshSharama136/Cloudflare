terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.0"
    }
       azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.arm_subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  tenant_id       = var.arm_tenant_id
  features {}
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["get-token", "--login", "azurecli", "--server-id", yamldecode(data.azurerm_kubernetes_cluster.aks.kube_config_raw).users[0].user.exec.args[4]]
      command     = "kubelogin"
  }
}


provider "cloudflare" {
  api_token = var.cloudflared_api_token
}