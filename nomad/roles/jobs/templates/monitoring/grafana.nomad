job "grafana" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "monitoring" {
		count = 1
		restart {
			attempts = 3
			delay = "15s"
			mode = "delay"
		}
		network {
			port "grafana_ui" {
				to = 3000
				static = 25400
			}
		}
		task "grafana" {
			driver = "docker"
			config {
				image = "grafana/grafana:8.0.6"
				force_pull = true
				ports = ["grafana_ui"]
				mount {
					type = "bind"
					target = "/var/lib/grafana"
					source = "/mnt/shared/grafana"
					readonly = false
					bind_options {
						propagation = "rshared"
					}
				}
			}
			env {
				GF_INSTALL_PLUGINS = "camptocamp-prometheus-alertmanager-datasource"
			}
			resources {
				cpu = 100
				memory = 128
			}
			service {
				name = "grafana"
				port = "grafana_ui"
        tags = ["urlprefix-/grafana/ strip=/grafana", "monitoring", "visualization"]
        check {
          name     = "grafana_ui port alive"
          type     = "http"
          path     = "/api/health"
          interval = "10s"
          timeout  = "2s"
        }
			}
		}
	}
}
