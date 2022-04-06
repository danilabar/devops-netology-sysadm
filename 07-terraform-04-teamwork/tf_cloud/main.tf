provider "yandex" {
 token     = var.yc_token
# cloud_id  = "b1g62d8ululsummdnj71"
 cloud_id  = var.yc_cloud_id
# folder_id = "b1goaocmukt0m7s34gke"
 folder_id = var.yc_folder_id
 zone      = var.yc_region
}

resource "yandex_compute_instance" "vm1" {
  name     = "vm1"
  hostname = "vm1.netology.cloud"
  zone     = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = var.yc_image_id
      name        = "root-vm1"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

#  metadata = {
#    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_region
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
