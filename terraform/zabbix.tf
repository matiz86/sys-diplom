resource "yandex_compute_instance" "zbxserver" {
  name = "zbxserver"
  zone = "ru-central1-b"
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
    subnet_id = yandex_vpc_subnet.subnet4.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

output "zbx" {
  value = yandex_compute_instance.zbxserver.network_interface.0.ip_address
}
