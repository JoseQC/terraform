provider "azurerm" {
    version = "~>2.0"
    subscription_id     = "${var.azure_subscription_id}"
    tenant_id           = "${var.azure_tenenat_tenant_id}"
    features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${var.prefix}-k8s-resources"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  dns_prefix          = "${var.prefix}-k8s"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
            key_data = file(var.ssh_public_key)
        }
  }

    service_principal {
    client_id     = "${var.kubernetes_client_id}"
    client_secret = "${var.kubernetes_client_secret}"
  }

   default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  tags = {
    Environment = "Production"
  }
}