// DB cluster
resource "yandex_mdb_mysql_cluster" "cluster-mysql-netology" {
  name                = "mysql-netology"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.network-1.id
  version             = "8.0"
  folder_id           = var.yandex_folder_id
  deletion_protection = true

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  resources {
    resource_preset_id = "b1.medium" # Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = var.a-zone
    subnet_id = yandex_vpc_subnet.subnet-private-a.id
  }

  host {
    zone      = var.b-zone
    subnet_id = yandex_vpc_subnet.subnet-private-b.id
  }

}

// Generate password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!-_?"
}

// Database
resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-netology.id
  name       = var.db_name
}

// Database user account
resource "yandex_mdb_mysql_user" "db_user" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-netology.id
  name       = var.db_user
  password   = random_password.db_password.result
  depends_on = [random_password.db_password]


  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }


  connection_limits {
    max_questions_per_hour   = 1000
    max_updates_per_hour     = 2000
    max_connections_per_hour = 3000
    max_user_connections     = 40
  }

  global_permissions = ["PROCESS"]

  authentication_plugin = "SHA256_PASSWORD"
}

resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    description    = "phpmyadmin"
    port           = 3306
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}