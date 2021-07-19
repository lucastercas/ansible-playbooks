job "prometheus" {
	region = "global"
  datacenters = ["dc1"]
  type        = "service"
	update {
		max_parallel = 1
		stagger = "10s"
		auto_revert = true
	}
  group "monitoring" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }
		network {
			port  "prometheus_ui" { to = 9090 }
		}
    service {
      name = "prometheus"
      port = "prometheus_ui"
      tags = [
        "metrics", "monitoring",
        "traefik.enable=true",
        "traefik.http.routers.prometheus.rule=PathPrefix(`/prometheus`)"
      ]
      check {
        name     = "Prometheus healthcheck"
        type     = "http"
        path     = "/prometheus/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "prometheus" {
      driver = "docker"
      config {
        image = "prom/prometheus:v2.28.1"
				force_pull = true
				ports = ["prometheus_ui"]
        mount {
          type = "bind"
          target = "/prometheus"
          source = "/mnt/shared/prometheus"
          readonly = false
        }
        volumes = [
					"local/webserver_alert.yml:/etc/prometheus/alerts.yml",
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
				args = [
					"--config.file=/etc/prometheus/prometheus.yml",
					"--web.enable-lifecycle",
					"--web.enable-admin-api",
					"--web.external-url=/prometheus/",
				]
      }
			resources {
				cpu = 50
				memory = 128
			}
      template {
        change_mode = "noop"
        destination = "local/webserver_alert.yml"
        data = <<EOF
---
groups:
  - name: prometheus_alerts
    rules:
      - alert: Webserver down
        expr: absent(up{job="webserver"})
        for: 10s
        labels:
          severity: critical
        annotations:
          description: "Our webserver is down."
EOF
      }
      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"
        data = <<EOF
---
global:
  scrape_interval: 5s
  evaluation_interval: 5s
alerting:
  alertmanagers:
    - consul_sd_configs:
        - server: '192.168.0.30:8500'
          services: ["alertmanager"]
rule_files:
  - "/etc/prometheus/alerts.yml"
scrape_configs:
  - job_name: "services"
    scrape_interval: 5s
    consul_sd_configs:
      - server: "192.168.0.30:8500"
    relabel_configs:
      - source_labels: ["__meta_consul_service"]
        target_label: "service"
  - job_name: "nomad_metrics"
    scrape_interval: 5s
    metrics_path: /v1/metrics
    consul_sd_configs:
      - server: "192.168.0.30:8500"
        services: ["nomad-client", "nomad"]
    relabel_configs:
      - source_labels: ["__meta_consul_tags"]
        regex: "(.*)http(.*)"
        action: keep
      - source_labels: ["__meta_consul_service"]
        target_label: "service"
    params:
      format: ["prometheus"]
        EOF
      }
    }
  }
}
