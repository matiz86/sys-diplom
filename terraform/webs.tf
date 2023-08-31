# Web Server 1

resource "yandex_compute_instance" "web1" {

  name     = "web1"
  zone     = "ru-central1-a"
  hostname = "web1.srv."

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
      size     = 12
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    dns_record {
      fqdn = "web1.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security_group-private.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

# Web Server 2

resource "yandex_compute_instance" "web2" {

  name     = "web2"
  zone     = "ru-central1-b"
  hostname = "web2.srv."

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
      size     = 12
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    dns_record {
      fqdn = "web2.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security_group-private.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

# Zabbix Server

resource "yandex_compute_instance" "zabbix" {

  name     = "zabbix"
  zone     = "ru-central1-b"
  hostname = "prometheus.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 12
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet3-zabbix.id
    dns_record {
      fqdn = "zabbix.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security_group-private.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

# ElasticSearch Server

resource "yandex_compute_instance" "elasticsearch" {

  name     = "elasticsearch"
  zone     = "ru-central1-a"
  hostname = "elasticsearch.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 14
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet4-elastic.id
    dns_record {
      fqdn = "elastic.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security_group-private.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

# Kibana server

resource "yandex_compute_instance" "kibana" {

  name     = "kibana"
  zone     = "ru-central1-a"
  hostname = "kibana.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o41nbel1uqngk0op2"
      size     = 14
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.subnet5-kibana.id
    dns_record {
      fqdn = "kibana.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security_group-public.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}

# Ssh Server

resource "yandex_compute_instance" "ssh" {

  name     = "ssh"
  zone     = "ru-central1-a"
  hostname = "ssh.srv."

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
      size     = 12
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet6-ssh.id
    dns_record {
      fqdn = "ssgw.srv."
      ttl  = 300
    }
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-ssh.id]
  }

  metadata = {

    user-data = "${file("./meta.txt")}"
  }
}
