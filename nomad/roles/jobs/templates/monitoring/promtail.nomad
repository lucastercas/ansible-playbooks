job "promtail" {
	region = "global"
  datacenters = ["dc1"]
  type        = "service"
	group "promtail" {
		count = 1
		network {
			port "promtail" { to = 3000 }
      port "http" { to = 9080}
		}
    service {
      name = "promtail"
      port = "http"
      tags = [
        "monitoring", "logs"
      ]
      check {
        name = "Promtail healthcheck"
        type = "http"
        path = "/ready"
        interval = "10s"
        timeout = "2s"
      }
    }
		task "promtail" {
			driver = "docker"
			config {
				image = "grafana/promtail:k55-1ed19f7-arm64"
				force_pull = true
				ports = ["promtail"]
        args = [
          "-config.file", "local/config.yaml",
        ]
				volumes = [
					"/var/log/journal/:/var/log/journal",
					"/run/log/journal/:/run/log/journal",
					"/etc/machine-id:/etc/machine-id",
				]
			}
			resources {
				cpu = 50
				memory = 64
			}
      template {
        data = <<EOH
server:
  http_listen_port: 9080
  grpc_listen_port: 0
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://192.168.0.31/loki/loki/api/v1/push
scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
  - job_name: journal
    journal:
      json: false
      max_age: 12h
      path: /var/log/journal
      labels:
        job: systemd-journal
    relabel_configs:
      - source_labels: ['__journal__systemd_unit']
        target_label: 'unit'
EOH
        destination = "local/config.yaml"
      }

		}
	}
}