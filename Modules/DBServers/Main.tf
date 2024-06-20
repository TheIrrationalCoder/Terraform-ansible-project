#Public IP for webserver
resource "azurerm_public_ip" "dbserver_public_ip" {
  name                = var.dbserver_public_ip
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

# Network Interface 
resource "azurerm_network_interface" "dbservernic" {
  name                = var.db_server_nic
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.db_server_ip_config
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.dbserver_public_ip.id
  }
}

#NSG for DBServer (optional)
resource "azurerm_network_security_group" "db_inbound_nsg" {
  name                = "db_inbound_nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

#Traffic rule to allow SSH and access http
resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "ssh_rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.my_public_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db_inbound_nsg.name
}

/*
resource "azurerm_network_security_rule" "mongodb_inbound_rule" {
  name                        = "mongodb_inbound_rule"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "27017"
  source_address_prefix       = var.webserver_public_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db_inbound_nsg.name
}

resource "azurerm_network_security_rule" "mongodb_outbound_rule" {
  name                        = "mongodb_outbound_rule"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "27017"
  source_address_prefix       = "*"
  destination_address_prefix  = var.webserver_public_ip
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db_inbound_nsg.name
}
*/

#Associate NSG with the nic
resource "azurerm_network_interface_security_group_association" "example_1" {
  network_interface_id      = azurerm_network_interface.dbservernic.id
  network_security_group_id = azurerm_network_security_group.db_inbound_nsg.id
}

# VM
resource "azurerm_virtual_machine" "dbvm" {
  name                  = var.db_server_vm
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.dbservernic.id]
  vm_size               = var.server_instance

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }
  storage_os_disk {
    name              = var.db_server_disk_name
    caching           = var.disk_caching
    create_option     = var.disk_create_option
    managed_disk_type = var.disk_type
  }
  os_profile {
    computer_name  = var.db_server_computer_name
    admin_username = var.server_username
    admin_password = var.server_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "dbserver-ip-address" {
    value = azurerm_public_ip.dbserver_public_ip.ip_address
}