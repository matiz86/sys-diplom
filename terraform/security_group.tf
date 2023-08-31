# sg balancer

resource "yandex_vpc_security_group" "security_group-balancer" {
  name       = "security_group-balancer"
  network_id = yandex_vpc_network.diplom.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }
}

# sg private

resource "yandex_vpc_security_group" "security_group-private" {
  name       = "security_group-private"
  network_id = yandex_vpc_network.diplom.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "balancer"
    security_group_id = yandex_vpc_security_group.security_group-balancer.id
    port              = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "elasticsearch"
    security_group_id = yandex_vpc_security_group.security_group-public.id
    port              = 9200
  }

  ingress {
    protocol          = "TCP"
    description       = "zabbix"
    security_group_id = yandex_vpc_security_group.security_group-public.id
    port              = 10051
  }

  ingress {
    protocol          = "TCP"
    description       = "alert manager"
    security_group_id = yandex_vpc_security_group.security_group-public.id
    port              = 9093
  }


  ingress {
    protocol          = "ANY"
    description       = "any"
    security_group_id = yandex_vpc_security_group.security_group-ssh.id
  }

}


# sg public

resource "yandex_vpc_security_group" "security_group-public" {
  name       = "security_group-public"
  network_id = yandex_vpc_network.diplom.id


  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "kibana"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  ingress {
    protocol          = "ANY"
    description       = "any"
    security_group_id = yandex_vpc_security_group.security_group-ssh.id
  }

}

# sg sshgw 

resource "yandex_vpc_security_group" "security_group-ssh" {
  name       = "security_group-ssh"
  network_id = yandex_vpc_network.diplom.id


  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}
