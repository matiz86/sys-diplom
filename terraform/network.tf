# Создание сети и подсети
resource "yandex_vpc_network" "matiz-sys" {
  name = "matiz-sys"
}
# Создание подсетей
resource "yandex_vpc_subnet" "subnet1" {
  name           = "web1_private"
  zone           = "ru-central1-a"
  description    = "subnet for web1_private"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
resource "yandex_vpc_subnet" "subnet2" {
  name           = "web2_private"
  zone           = "ru-central1-b"
  description    = "subnet for web2_private"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet3" {
  name           = "web3_private"
  zone           = "ru-central1-b"
  description    = "subnet for services"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}

resource "yandex_vpc_subnet" "subnet4" {
  name           = "pub"
  zone           = "ru-central1-b"
  description    = "subnet for bastion"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.4.0/24"]
}

resource "yandex_vpc_subnet" "subnet5" {
  name           = "logs"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.5.0/24"]
}
#Создание группы безопасности

resource "yandex_vpc_security_group" "webs" {
  name        = "webs"
  description = "description for my security group"
  network_id  = yandex_vpc_network.matiz-sys.id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    port           = 80
  }
}

resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana"
  description = "description for my security group"
  network_id  = yandex_vpc_network.matiz-sys.id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.4.0/24"]
    port           = 5601
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.4.0/24"]
    port           = 5601
  }
}

resource "yandex_vpc_security_group" "zbxserver" {
  name        = "zbxserver"
  description = "description for my security group"
  network_id  = yandex_vpc_network.matiz-sys.id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.4.0/24"]
    port           = 10051
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.4.0/24"]
    port           = 10051
  }
}
