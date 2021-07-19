job "alertmanager" {
	region = "global"
  datacenters = ["dc1"]
  type = "service"
  group "alerting" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
		network {
			port "alertmanager_ui" {
				to = 9093
				static = 23455
			}
		}
    task "alertmanager" {
      driver = "docker"
      config {
        image = "prom/alertmanager:latest"
				ports = ["alertmanager_ui"]
      }
			resources {
				cpu = 100
				memory = 128
			}
      service {
        name = "alertmanager"
        tags = [
          "monitoring", "alerts",
          "traefik.enable=true", "traefik.http.routers.alertmanager.rule=Path(`/alertmanager`)"
        ]
        port = "alertmanager_ui"
        check {
          name     = "Alertmanager healthcheck"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

