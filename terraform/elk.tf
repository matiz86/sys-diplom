# ELK 

resource "yandex_compute_instance" "elasticsearch" {

  zone = "ru-central1-b"
  name = "elasticsearch"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 6
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet3.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "kibana" {

  zone = "ru-central1-b"
  name = "kibana"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet4.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
