# Создание сети и подсети
resource "yandex_vpc_network" "diplom" {

  name = "diplom"
}

# Subnet web1

resource "yandex_vpc_subnet" "subnet-1" {

  name           = "web1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["10.0.1.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# Subnet web2

resource "yandex_vpc_subnet" "subnet-2" {

  name           = "web2"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.2.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}


# Subnet zabbix

resource "yandex_vpc_subnet" "subnet-zabbix" {

  name           = "subnet-zabbix"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.3.0/24"]
  network_id     = yandex_vpc_network.diplom.id
}

# resource "yandex_vpc_subnet" "subnet4" {
#   name           = "pub"
#   zone           = "ru-central1-b"
#   description    = "subnet for bastion"
#   network_id     = yandex_vpc_network.matiz-sys.id
#   v4_cidr_blocks = ["10.0.4.0/24"]
# }

# resource "yandex_vpc_subnet" "subnet5" {
#   name           = "logs"
#   zone           = "ru-central1-b"
#   network_id     = yandex_vpc_network.matiz-sys.id
#   v4_cidr_blocks = ["10.0.5.0/24"]
# }
