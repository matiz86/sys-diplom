# # ELK 

# resource "yandex_compute_instance" "elasticsearch" {

#   zone = "ru-central1-b"
#   name = "elasticsearch"

#   resources {
#     core_fraction = 20
#     cores         = 2
#     memory        = 8
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd8gqjo661d83tv5dnv4"
#       size     = 15
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.subnet3.id
#     nat                = true
#     security_group_ids = [yandex_vpc_security_group.sg-private.id]
#   }

#   metadata = {
#     user-data = "${file("./meta.txt")}"
#   }
# }

# resource "yandex_compute_instance" "kibana" {

#   zone = "ru-central1-b"
#   name = "kibana"

#   resources {
#     core_fraction = 20
#     cores         = 2
#     memory        = 4
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd8gqjo661d83tv5dnv4"
#       size     = 10
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.subnet4.id
#     nat                = true
#     security_group_ids = [yandex_vpc_security_group.sg-public.id]
#   }


#   metadata = {
#     user-data = "${file("./meta.txt")}"
#   }
# }

# output "internal-elastic" {
#   value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
# }

# output "internal-kibana" {
#   value = yandex_compute_instance.kibana.network_interface.0.ip_address
# }
# output "external-kibana" {
#   value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
# }
