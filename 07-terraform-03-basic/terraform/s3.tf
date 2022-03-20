terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-terraform"
    region     = "ru-central1-a"
    key        = "terraform/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}