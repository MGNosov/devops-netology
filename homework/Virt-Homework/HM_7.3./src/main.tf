terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test01"
    region     = "ru-central1"
    key        = "~/terraform.tfstate"
    access_key = "YCAJE3TnnQHY1mG5FA7CnJpw1"
    secret_key = "YCPlSskQ0KF6ir5UjVVEhhF5DRvqy3YLNrm5p5Vw"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "AQAAAAAnxe1uAATuwbFCSoUwM0v_p5OSKy3TFf0"
  cloud_id  = "b1g9cb14mht57dso4pco"
  folder_id = "b1gi5ufjf161iudar0ce"
  zone      = "ru-central1-a"
}

locals {
  web_instance_count_map = {
    stage = 1
    prod = 2
  }
}

resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"
  count                     = local.web_instance_count_map[terraform.workspace]
  lifecycle {
    create_before_destroy = true
  }
  resources {
    cores  = 8
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-node01"
      type        = "network-nvme"
      size        = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}