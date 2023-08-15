# Создание сети
resource "yandex_vpc_network" "network1" {
  name = "network1"
}
# Создание подсетей
resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}
