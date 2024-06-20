# Create the Resource Group -- Add tfvar file for these values***
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}