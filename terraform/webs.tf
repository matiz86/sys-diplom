# Web-Серверы 

resource "yandex_compute_instance" "web1" {

  name = "web1"
  zone = "ru-central1-b"

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true

  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "web2" {

  name = "web2"
  zone = "ru-central1-a"


  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id

    nat = true

  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}


# Target Groups

resource "yandex_alb_target_group" "tg-group" {
  name = "tg-group"

  target {
    subnet_id  = yandex_vpc_subnet.subnet-1.id
    ip_address = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet-2.id
    ip_address = yandex_compute_instance.web2.network_interface.0.ip_address
  }

}

# Backend_group

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.tg-group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout             = "5s"
      interval            = "3s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Http-router 

resource "yandex_alb_http_router" "router" {
  name = "router"

}

resource "yandex_alb_virtual_host" "router-host" {
  name           = "router-host"
  http_router_id = yandex_alb_http_router.router.id
  route {
    name = "router1"
    http_route {

      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "5s"
      }
    }
  }
}

# Alb address

resource "yandex_vpc_address" "addr" {
  name = "addr"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# Alb_load_balancer

resource "yandex_alb_load_balancer" "alb" {
  name       = "alb"
  network_id = yandex_vpc_network.diplom.id
  # security_group_ids = [yandex_vpc_security_group.sg-balancer.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-2.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-1.id
    }
  }

  listener {
    name = "listener-1"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.addr.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.router.id
      }
    }
  }
}

# output "web1_private" {
#   value = yandex_compute_instance.nginxvm1.network_interface.0.ip_address
# }

# output "web2_private" {
#   value = yandex_compute_instance.nginxvm2.network_interface.0.ip_address
# }

# output "load_balancer_pub" {
#   value = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address
# }
