output "db_password" {
  value = random_password.db_password.result
  sensitive = true
}

output "cluster_mysql_hostname" {
    value = [for h in yandex_mdb_mysql_cluster.cluster-mysql-netology.host : h.fqdn]
    }
