# Создание сети и подсети
resource "yandex_vpc_network" "matiz-sys" {
  name = "matiz-sys"
}
# Создание подсетей
resource "yandex_vpc_subnet" "subnet1" {
  name           = "web1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
resource "yandex_vpc_subnet" "subnet2" {
  name           = "web2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.matiz-sys.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

#Создание группы безопасности

resource "yandex_vpc_security_group" "webs" {
  name        = "webs"
  description = "description for my security group"
  network_id  = yandex_vpc_network.diplom.id

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
