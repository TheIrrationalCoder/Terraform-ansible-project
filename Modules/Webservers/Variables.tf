variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "web_server_nic" {
  type = string
}

variable "web_server_ip_config" {
    type = string
}

variable "web_server_vm" {
    type = string
}

variable "web_server_disk_name" {
    type = string
}

variable "web_server_computer_name" {
    type = string
}

variable "webserver_public_ip" {
    type = string
}

#Common attributes for the Web and DB Servers

variable "server_instance" {
    type = string
}

variable "os_publisher" {
    type = string
}

variable "os_offer" {
    type = string
}

variable "os_sku" {
  type = string
}

variable "os_version" {
  type = string
}

variable "disk_caching" {
    type = string
}

variable "disk_create_option" {
    type = string
}

variable "disk_type" {
    type = string 
}

variable "server_username" {
    type = string
}

variable "server_password" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "my_public_ip" {
    type = string
}