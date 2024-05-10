variable "arm_client_id" {
  type        = string
  description = "The client Id of azure provider spn"
}

variable "arm_client_secret" {
  type        = string
  sensitive   = true
  description = "The client secret of azure provider spn"
}


variable "arm_tenant_id" {
  type        = string
  description = "The tenant Id of azure provider"
  default     = "ff93404f-c1e7-43e5-ab53-a9b9d85c1f98"
}

variable "arm_subscription_id" {
  type        = string
  description = "The subscription Id of azure provider"
}

variable "cloudflared_account_id" {
  type        = string
}

variable "cloudflared_api_token" {
  type        = string
}

variable "cloudflared_tunnel_secret" {
  type        = string
}




variable "environment" {
  type        = string
  description = "The environment to deploy in"
  validation {
    condition     = var.environment == "Dev" || var.environment == "QA" || var.environment == "Prod" || var.environment == "DevPOC" || var.environment == "Uat"
    error_message = "The value for environment can only be \"Dev\" or \"DevPOC\" or \"QA\" or \"Prod\"!"
  }
}

variable "resource_name" {
  type = string
}

variable "instance_number" {
  type    = string
  default = "01"
}

variable "aks_resource_group_name" {
  type        = string
  default     = ""
}


variable "aks_name" {
  type        = string
  default     = ""
}

variable "zone_name" {
  type        = string
}

variable "ingress_list"  {
  type   =  list(any)
}

variable "hostnames"  {
  type   =  list(string)
}

variable "namespace"  {
  type   = string
}


variable "tunnel_name" {
  type        = string
}

variable "create_namespace" {
  type        = bool
  default     = false
}