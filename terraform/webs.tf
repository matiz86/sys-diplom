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

