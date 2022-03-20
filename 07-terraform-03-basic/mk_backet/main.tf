terraform {
 required_providers {
   yandex = {
     source  = "yandex-cloud/yandex"
   }
 }
 required_version = ">= 0.13"
}

provider "yandex" {
 cloud_id  = "b1g62d8ululsummdnj71"
 folder_id = "b1goaocmukt0m7s34gke"
 zone      = "ru-central1-a"
}

resource "yandex_storage_bucket" "netology" {
  access_key = ""
  secret_key = ""
  bucket = "netology-terraform"
}