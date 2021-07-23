job "node-exporter" {
	region = "global"
	datacenters = ["dc1"]
	type = "system"

	group "monitoring" {
		count = 1
		restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }
		network {
			port "http" { to = 9100}
		}
    service {
      name = "node-exporter"
      tags = ["metrics", "monitoring"]
      port = "http"
      check {
        name = "Node Exporter healthcheck"
        type = "http"
        path = "/metrics"
        interval = "10s"
        timeout = "2s"
      }
    }
		task "node-exporter" {
			driver = "docker"
			config {
				image = "prom/node-exporter:v1.2.0"
				force_pull = true
				ports = ["http"]
				volumes = [
          "/proc:/host/proc",
          "/sys:/host/sys",
          "/:/rootfs"
        ]
				logging {
          type = "journald"
          config {
            tag = "NODE-EXPORTER"
          }
        }
			}
			resources {
				cpu = 50
				memory = 100
			}
		}
	}
}
