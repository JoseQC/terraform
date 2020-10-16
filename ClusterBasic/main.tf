provider "azurerm" {
  features {}
}

data "azurerm_suscription" "current" {}

resource "azurerm_resource_group" "rgid" {
  name     = "rg${local.alias}"
  location = var.region
}

resource "azurerm_container_registry" "acr"{
  name = "acr${local.alias}01"
  location = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
  sku = "Basic"
  admin_enabled = true
}

resource "azurerm_virtual_network" "vnetid"{
  name = "vnet${local.alias}"
 location = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
  address_space = ["11.0.0.0/16"]

  }

resource "azurerm_kubernetes_cluster" "aksid"
{

name = "aks${local.alias}pe"
  location = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
dns_prefix = "aks${local.alias}pe"

defauld_node_pool{
name = "default"
node_count = local.workers
vm_size = local.instancia
min_count=local.workers
max_count = 5
os_disk_size_gb = 30
type="Virtual_MachineScaleSets"
availabity_zones = [1,2,3]
enable_auto_scaling = true
vnet_subnet_id = "/subcriptions/${data.azurerm_suscription.current.subcriptions_id}/resource"

}

service_principal{
  client_id = local.client_id
  client_secret=local.clientsecret
}


network_profile{
  network_plugin = "azure"
  load_balancer_sku = "standard"
}

tag = {
  Environment = "Production"
}







}



}