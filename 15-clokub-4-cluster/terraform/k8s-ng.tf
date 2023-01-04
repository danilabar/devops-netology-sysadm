resource "yandex_kubernetes_node_group" "k8s-ng" {
  cluster_id  = "${yandex_kubernetes_cluster.netology-k8s-cluster.id}"
  name        = "k8s-node-group"
  description = "kubernetes node group"
  version     = "1.22"

  instance_template {
    platform_id = "standard-v2"

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }

    network_interface {
      nat                = true
      subnet_ids         = [
        "${yandex_vpc_subnet.subnet-public-a.id}"
      ]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }

  allocation_policy {
      location {
        zone      = "${yandex_vpc_subnet.subnet-public-a.zone}"
      }
  }

}