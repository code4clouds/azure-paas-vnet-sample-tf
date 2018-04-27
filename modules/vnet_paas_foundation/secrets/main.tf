provider "azurerm" {}
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "ops" {
  name = "${var.resource_group_name}"
}

resource "azurerm_key_vault" "main" {
  name                = "${var.resource_prefix}-vault"
  location            = "${data.azurerm_resource_group.ops.location}"
  resource_group_name = "${data.azurerm_resource_group.ops.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"
  tags                = "${var.tags}"

  sku {
    name = "${var.key_vault_sku}"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${var.key_vault_deployer_object_id}"

    key_permissions         = ["get"]
    secret_permissions      = ["get"]
    certificate_permissions = ["get", "list", "create"]
  }

  # Configure diagnostic settings
  provisioner "local-exec" {
    command = "${var.diagnostic_commands["key_vault"]}"

    environment {
      resource_id = "${azurerm_key_vault.main.id}"
    }
  }

  # Generate APIM self-signed cert
  provisioner "local-exec" {
    command     = "${path.module}/scripts/generate_cert.sh"
    environment = "${merge(var.apim_cert_config, map("vault_name", azurerm_key_vault.main.name))}"
  }

  # Generate ASE self-signed cert
  provisioner "local-exec" {
    command     = "${path.module}/scripts/generate_cert.sh"
    environment = "${merge(var.ase_cert_config, map("vault_name", azurerm_key_vault.main.name))}"
  }
}

data "external" "apim_ssl_cert" {
  program = [
    "${path.module}/scripts/get_key_vault_certificate.sh",
    "${var.apim_cert_config["cert_name"]}",
    "${azurerm_key_vault.main.name}"
  ]
}

data "external" "ase_ssl_cert" {
  program = [
    "${path.module}/scripts/get_key_vault_certificate.sh",
    "${var.ase_cert_config["cert_name"]}",
    "${azurerm_key_vault.main.name}"
  ]
}