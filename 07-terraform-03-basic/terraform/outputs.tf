output "internal_ip_address_instance_1" {
  value = {
    for node in yandex_compute_instance.instance-1:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_instance_1" {
  value = {
    for node in yandex_compute_instance.instance-1:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}

output "internal_ip_address_instance_2" {
  value = {
    for node in yandex_compute_instance.instance-2:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_instance_2" {
  value = {
    for node in yandex_compute_instance.instance-2:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}