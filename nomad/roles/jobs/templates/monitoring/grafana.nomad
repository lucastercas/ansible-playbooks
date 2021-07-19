job "grafana" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"
	update {
		max_parallel = 1
		stagger = "10s"
		auto_revert = true
	}
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
		service {
			name = "grafana"
			port = "grafana_ui"
			tags = [
				"monitoring", "visualization",
				"traefik.enable=true",
				"traefik.http.routers.grafana.rule=Path(`/grafana`) || PathPrefix(`/grafana/`)"
			]
			check {
				name     = "Grafana healthcheck"
				type     = "http"
				path     = "/api/health"
				interval = "10s"
				timeout  = "2s"
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
				GF_SERVER_ROOT_URL = "%(protocol)s://%(domain)s:%(http_port)s/grafana"
				GF_SERVER_SERVE_FROM_SUB_PATH = "true"
			}
			resources {
				cpu = 100
				memory = 128
			}
		}
	}
}
