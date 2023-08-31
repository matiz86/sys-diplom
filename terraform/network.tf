# Network

resource "yandex_vpc_network" "diplom" {

  name = "diplom"
}

# Subnet web1

resource "yandex_vpc_subnet" "subnet-1" {

  name           = "subnet-web1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# Subnet web2

resource "yandex_vpc_subnet" "subnet-2" {

  name           = "subnet-web2"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["10.0.2.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# Subnet Zabbix

resource "yandex_vpc_subnet" "subnet3-zabbix" {

  name           = "subnet-zabbix"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["10.0.3.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}


# Subnet elasticsearch

resource "yandex_vpc_subnet" "subnet4-elastic" {

  name           = "subnet-elastic"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.4.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# Subnet kibana

resource "yandex_vpc_subnet" "subnet5-kibana" {

  name           = "subnet-kibana"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.5.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# Subnet ssh

resource "yandex_vpc_subnet" "subnet6-ssh" {

  name           = "subnet-ssh"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.6.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}


# alb address

resource "yandex_vpc_address" "addr-1" {
  name = "addr-1"

  external_ipv4_address {
    zone_id = "ru-central1-b"
  }
}

# Target group for ALB

resource "yandex_alb_target_group" "target_group" {
  name = "target_group"

  target {
    subnet_id  = yandex_compute_instance.web1.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_compute_instance.web2.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.web2.network_interface.0.ip_address
  }
}

# Backend group for ALB

resource "yandex_alb_backend_group" "backend_group" {
  name = "backend_group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.target_group.id}"]

    load_balancing_config {
      panic_threshold = 9
    }
    healthcheck {
      timeout             = "5s"
      interval            = "2s"
      healthy_threshold   = 2
      unhealthy_threshold = 10
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# ALB router

resource "yandex_alb_http_router" "router" {
  name = "router"
}

# ALB virtual host

resource "yandex_alb_virtual_host" "vh-1" {
  name           = "vh-1"
  http_router_id = yandex_alb_http_router.router.id

  route {
    name = "route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend_group.id
        timeout          = "3s"
      }
    }
  }
}

# ALB

resource "yandex_alb_load_balancer" "alb" {
  name               = "alb"
  network_id         = yandex_vpc_network.diplom.id
  security_group_ids = [yandex_vpc_security_group.sg-balancer.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-web1.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-web2.id
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.addr-1.external_ipv4_address[0].address
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

# Output

output "internal-web1" {
  value = yandex_compute_instance.web1.network_interface.0.ip_address
}

output "internal-web2" {
  value = yandex_compute_instance.web2.network_interface.0.ip_address
}

output "internal-zabbix" {
  value = yandex_compute_instance.zabbix.network_interface.0.ip_address
}

output "internal-elastic" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
}

output "internal-kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}
output "external-kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}

output "internal-ssh" {
  value = yandex_compute_instance.ssh.network_interface.0.ip_address
}
output "external-ssh" {
  value = yandex_compute_instance.ssh.network_interface.0.nat_ip_address
}

#output "external-alb" {
#  value = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
#}

output "external-alb" {
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}
