#Bastion Host

resource "yandex_compute_instance" "bastion" {

  zone = "ru-central1-b"
  name = "bastion"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8gqjo661d83tv5dnv4"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-kibana.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
