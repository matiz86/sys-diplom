# # Security group public load balancer 
# resource "yandex_vpc_security_group" "sg-balancer" {
#   name       = "sg-balancer"
#   network_id = yandex_vpc_network.matiz-sys.id

#   ingress {
#     protocol       = "TCP"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 80
#   }

#   egress {
#     protocol       = "ANY"
#     v4_cidr_blocks = ["0.0.0.0/0"]


#   }
#   ingress {
#     protocol          = "TCP"
#     description       = "healthchecks"
#     predefined_target = "loadbalancer_healthchecks"
#     port              = 30080
#   }
# }

# # sg private

# resource "yandex_vpc_security_group" "sg-private" {
#   name       = "sg-private"
#   network_id = yandex_vpc_network.matiz-sys.id

#   egress {
#     protocol       = "ANY"
#     description    = "any"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     protocol          = "TCP"
#     description       = "balancer"
#     security_group_id = yandex_vpc_security_group.sg-balancer.id
#     port              = 80
#   }

#   ingress {
#     protocol          = "TCP"
#     description       = "elasticsearch"
#     security_group_id = yandex_vpc_security_group.sg-public.id
#     port              = 9200
#   }

#   ingress {
#     protocol          = "TCP"
#     description       = "zabbix"
#     security_group_id = yandex_vpc_security_group.sg-public.id
#     port              = 10050
#   }

#   ingress {
#     protocol          = "TCP"
#     description       = "alert manager"
#     security_group_id = yandex_vpc_security_group.sg-public.id
#     port              = 9093
#   }


#   ingress {
#     protocol          = "ANY"
#     description       = "any"
#     security_group_id = yandex_vpc_security_group.bastion.id
#   }

# }

# # sg public

# resource "yandex_vpc_security_group" "sg-public" {
#   name       = "sg-public"
#   network_id = yandex_vpc_network.matiz-sys.id


#   egress {
#     protocol       = "ANY"
#     description    = "any"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }


#   ingress {
#     protocol       = "TCP"
#     description    = "kibana"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 5601
#   }

#   ingress {
#     protocol          = "ANY"
#     description       = "any"
#     security_group_id = yandex_vpc_security_group.bastion.id
#   }

# }

# # sg bastion 

# resource "yandex_vpc_security_group" "bastion" {
#   name       = "bastion"
#   network_id = yandex_vpc_network.matiz-sys.id


#   egress {
#     protocol       = "ANY"
#     description    = "any"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }


#   ingress {
#     protocol       = "TCP"
#     description    = "ssh"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 22
#   }
# }
