terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

# Create the Resource Group -- Add tfvar file for optional default values
module "rg" {
  source   = "./Modules/RG"
  resource_group_name = "TAPResourceGroup"
  resource_group_location = "southindia"
}

# Create a virtual network within the Azure resource group
module "vnets" {
  source = "./Modules/VNETs"
  resource_group_name = "TAPResourceGroup"
  resource_group_location = "southindia"
  vnet_name = "TAPVnet"
  vnet_address_space = ["10.0.0.0/16"]
  subnet_name = "TAPSubnet"
  subnet_address_space = ["10.0.1.0/24"]
  depends_on = [ module.rg ]
}

############################################
# Create 2 VMs - 1 WebServer and 1 DB Server
############################################

###########
# WebServer
###########

module "webservers" {
  source = "./Modules/Webservers"
  resource_group_name = "TAPResourceGroup"
  resource_group_location = "southindia"
  webserver_public_ip = "webserver_public_ip"
  web_server_nic = "WebServer-nic"
  web_server_ip_config = "webtestconfiguration"
  subnet_id = "${module.vnets.vnet_subnet_id}"
  web_server_vm = "WebServer-vm"
  server_instance = "Standard_DS1_v2"
  os_publisher = "Canonical"
  os_offer = "0001-com-ubuntu-server-jammy"
  os_sku = "22_04-lts"
  os_version = "latest"
  web_server_disk_name = "webosdisk"
  disk_caching = "ReadWrite"
  disk_create_option = "FromImage"
  disk_type = "Standard_LRS"
  web_server_computer_name = "webserver"
  server_username = "testadmin"
  server_password = "Password1234!"
  my_public_ip = "49.205.251.26"
  depends_on = [ module.rg ]
}

###########
# DB Server
###########

module "dbservers" {
  source = "./Modules/DBServers"
  resource_group_name = "TAPResourceGroup"
  resource_group_location = "southindia"
  dbserver_public_ip = "dbserver_public_ip"
  db_server_nic = "DBServer-nic"
  db_server_ip_config = "dbtestconfiguration"
  subnet_id = "${module.vnets.vnet_subnet_id}"
  db_server_vm = "DBServer-vm"
  server_instance = "Standard_DS1_v2"
  os_publisher = "Canonical"
  os_offer = "0001-com-ubuntu-server-jammy"
  os_sku = "22_04-lts"
  os_version = "latest"
  db_server_disk_name = "dbosdisk"
  disk_caching = "ReadWrite"
  disk_create_option = "FromImage"
  disk_type = "Standard_LRS"
  db_server_computer_name = "dbserver"
  server_username = "testadmin"
  server_password = "Password1234!"
  my_public_ip = "49.205.251.26"
  webserver_public_ip = ""
  depends_on = [ module.rg ]
}

#######################################################
# Optional Step: Provision an Azure Container Registry
# This step is not needed if Docker Hub is used
#######################################################
resource "azurerm_container_registry" "acr" {
  name                = "mycontainerregistrytaproject"
  resource_group_name = "TAPResourceGroup"
  location            = "southindia"
  sku                 = "Basic"
  admin_enabled       = true
  depends_on = [ module.rg ]
}