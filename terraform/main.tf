terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


# Провайдер
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud
  folder_id = var.yc_folder
}

#Создание vm1, vm2

resource "yandex_compute_instance" "nginxvm1" {
  name = "nginxvm1"
  zone = "ru-central1-a"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8o41nbel1uqngk0op2"
      size        = 10
      description = "boot disk for nginx_server1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "nginxvm2" {
  name = "nginxvm2"
  zone = "ru-central1-b"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8o41nbel1uqngk0op2"
      size        = 10
      description = "boot disk for nginx_server1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
# Создаем виртуальые машины для сервисов

resource "yandex_compute_instance" "zbxserver" {
  name = "zbxserver"
  zone = "ru-central1-a"
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8o41nbel1uqngk0op2"
      size        = 30
      description = "boot disk for zbxserver"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "kibana" {
  name = "kibana"
  zone = "ru-central1-a"

  resources {
    cores         = 4
    core_fraction = 20
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8o41nbel1uqngk0op2"
      size        = 20
      description = "boot disk for kibana"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "elastic" {
  name = "elastic"
  zone = "ru-central1-a"

  resources {
    cores         = 4
    core_fraction = 20
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8o41nbel1uqngk0op2"
      size        = 20
      description = "boot disk for elastic"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

