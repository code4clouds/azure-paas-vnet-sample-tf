variable "primary_location" {}
variable "secondary_location" {}
variable "resource_prefix" {}
variable "base_hostname" {}

variable "base_tags" {
  default = {}
}

variable "ops_rg_name" {}
variable "ops_tags" {
  default = {
    Tier = "Ops"
  }
}
variable "key_vault_sku" {
  default = "standard"
}
variable "key_vault_deployer_object_id" {}

# Shared App Infrastructure

variable "shared_app_rg_name" {}
variable "shared_app_tags" {
  default = {
    Tier = "App"
  }
}
variable "apim_publisher_email" {}
variable "apim_publisher_name" {}
variable "apim_primary_capacity" {}
variable "apim_secondary_capacity" {}

# Monitoring

variable "oms_retention" {
  default = 30
}


# Networking

variable "networking_rg_name" {}
variable "networking_tags" {
  default = {
    Tier = "Networking"
  }
}

variable "diagnostic_retentions" {
  default = {
    apim        = 365
    app_gateway = 365
    key_vault   = 365
    nsg         = 365
  }
}


# Ingress

variable "waf_sku" {
  default = "WAF_Medium"
}

variable "waf_capacity" {
  default = 1
}

variable "dev_gateway_sku" {
  default = "Standard_Small"
}

variable "dev_gateway_capacity" {
  default = 1
}


variable "service_1_name" {
  default = "prefix-dev-service-1-web-app"
}
