resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-public-a" {
  name           = "public-a"
  zone           = var.a-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-public-b" {
  name           = "public-b"
  zone           = var.b-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet-public-c" {
  name           = "public-c"
  zone           = var.c-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_vpc_subnet" "subnet-private-a" {
  name           = "private-a"
  zone           = var.a-zone
  network_id     = yandex_vpc_network.network-1.id
  #route_table_id = yandex_vpc_route_table.nat-route-table.id
  v4_cidr_blocks = ["192.168.110.0/24"]
}

resource "yandex_vpc_subnet" "subnet-private-b" {
  name           = "private-b"
  zone           = var.b-zone
  network_id     = yandex_vpc_network.network-1.id
  #route_table_id = yandex_vpc_route_table.nat-route-table.id
  v4_cidr_blocks = ["192.168.120.0/24"]
}

resource "yandex_vpc_subnet" "subnet-private-c" {
  name           = "private-c"
  zone           = var.c-zone
  network_id     = yandex_vpc_network.network-1.id
  #route_table_id = yandex_vpc_route_table.nat-route-table.id
  v4_cidr_blocks = ["192.168.130.0/24"]
}
/*
resource "yandex_vpc_route_table" "nat-route-table" {
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat-instance-ip
  }
}
*/