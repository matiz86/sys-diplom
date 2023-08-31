resource "yandex_compute_instance" "zabbix" {

  name = "zabbix"
  zone = "ru-central1-a"
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8gqjo661d83tv5dnv4"
      size        = 30
      description = "boot disk for zbxserver"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-zabbix.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

output "zbxserver" {
  value = yandex_compute_instance.zabbix.network_interface.0.ip_address
}
