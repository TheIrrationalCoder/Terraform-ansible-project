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

#Public IP for webserver
resource "azurerm_public_ip" "webserver_public_ip" {
  name                = var.webserver_public_ip
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

# Network Interface 
resource "azurerm_network_interface" "webservernic" {
  name                = var.web_server_nic
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.web_server_ip_config
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webserver_public_ip.id
  }
}

# VM
resource "azurerm_virtual_machine" "webvm" {
  name                  = var.web_server_vm
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.webservernic.id]
  vm_size               = var.server_instance

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }
  storage_os_disk {
    name              = var.web_server_disk_name
    caching           = var.disk_caching
    create_option     = var.disk_create_option
    managed_disk_type = var.disk_type
  }
  os_profile {
    computer_name  = var.web_server_computer_name
    admin_username = var.server_username
    admin_password = var.server_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "webserver-ip-address" {
    value = azurerm_public_ip.webserver_public_ip.ip_address
}
