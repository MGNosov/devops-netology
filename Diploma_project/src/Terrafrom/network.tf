resource "yandex_vpc_network" "stage" {
  name        = "network"
  description = "Network for VMs"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "revproxy_subnet"
  description    = "Reverse proxy subnet"
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.stage.id}"
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "app_db_subnet"
  description    = "Wordpress and database subnet"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.stage.id}"
}

resource "yandex_vpc_subnet" "subnet3" {
  name           = "gitlab_runner_subnet"
  description    = "GitLab and Runner subnet"
  v4_cidr_blocks = ["10.3.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.stage.id}"
}

resource "yandex_vpc_subnet" "subnet4" {
  name           = "monitoring_subnet"
  description    = "Monitoring subnet"
  v4_cidr_blocks = ["10.4.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.stage.id}"
}