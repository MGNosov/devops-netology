resource "yandex_compute_instance" "revproxy" {
  name = "revproxy"
  zone = "ru-central1-a"
  hostname = "mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet1.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }

}

resource "yandex_compute_instance" "db01" {
  name = "database01"
  zone = "ru-central1-a"
  hostname = "db01.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet2.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
    }
}

resource "yandex_compute_instance" "db02" {
  name = "database02"
  zone = "ru-central1-a"
  hostname = "db02.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet2.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }
}

resource "yandex_compute_instance" "app" {
  name = "application"
  zone = "ru-central1-a"
  hostname = "app.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet2.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }
}

resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"
  zone = "ru-central1-a"
  hostname = "gitlab.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet3.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }
}

resource "yandex_compute_instance" "runner" {
  name = "runner"
  zone = "ru-central1-a"
  hostname = "runner.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet3.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }
}

resource "yandex_compute_instance" "monitoring" {
  name = "monitoring"
  zone = "ru-central1-a"
  hostname = "monitoring.mgnosov.site"
  allow_stopping_for_update = true

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.image_id}"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet4.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("~/downloads/final_project/terraform/iac/meta.txt")}"
  }
}
