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
