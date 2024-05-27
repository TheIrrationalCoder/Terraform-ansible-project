variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_space" {
  type = list
}

variable "vnet_subnet_id" {
  type = string
  default = ""
}
