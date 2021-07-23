job "loki" {
	region = "global"
	datacenters = ["dc1"]
  type        = "service"
	group "monitoring" {
		count = 1
		restart {
			attempts = 3
			delay = "15s"
			mode = "delay"
		}
		network {
			port "loki" {
				to = 3100
				static = 25410
			}
		}
    service {
      name = "loki"
      port = "loki"
      tags = [
        "logs", "monitoring",
        "traefik.enable=true",
        "traefik.http.routers.loki.rule=Path(`/loki`) || PathPrefix(`/loki/`)"
      ]
      check {
        name     = "Loki healthcheck"
        type     = "http"
        path     = "/loki/ready"
        interval = "10s"
        timeout  = "2s"
      }
    }
		task "loki" {
			driver = "docker"
			config {
				image = "grafana/loki:2.2.1-arm64"
				force_pull = true
				ports = ["loki"]
        args = [
          "-config.file=/etc/loki/local-config.yaml",
          "-server.path-prefix=/loki"
        ]
			}
			resources {
				cpu = 50
				memory = 64
			}
		}
	}
}
