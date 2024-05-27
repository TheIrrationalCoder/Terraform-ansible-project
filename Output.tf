output "webserver-ip-address" {
    value = "${module.webservers.webserver-ip-address}"
}

output "dbserver-ip-address" {
    value = "${module.dbservers.dbserver-ip-address}"
}
