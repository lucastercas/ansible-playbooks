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
		task "loki" {
			driver = "docker"
			config {
				image = "grafana/loki:2.2.1-arm64"
				force_pull = true
				ports = ["loki"]
			}
			resources {
				cpu = 50
				memory = 64
			}
			service {
				name = "loki"
				tags = ["urlprefix-/loki", "logs", "monitoring"]
				port = "loki"
        check {
          name     = "loki port alive"
          type     = "http"
          path     = "/ready"
          interval = "10s"
          timeout  = "2s"
        }
			}
		}
	}
}