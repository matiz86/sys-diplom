# Web-Серверы 

resource "yandex_compute_instance" "nginxvm1" {
  name = "nginxvm1"
  zone = "ru-central1-a"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
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
    memory        = 2
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

# Target Groups

resource "yandex_alb_target_group" "tg-group" {
  name = "tg-group"

  target {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    ip_address = yandex_compute_instance.nginxvm1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet2.id
    ip_address = yandex_compute_instance.nginxvm2.network_interface.0.ip_address
  }

}
