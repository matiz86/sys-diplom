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
