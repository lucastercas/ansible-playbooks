job "node-exporter" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

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
			service {
				name = "node-exporter"
				// address_mode = "driver"
				tags = ["metrics", "monitoring"]
				port = "http"
				check {
					name = "node-exporter is alive"
          type = "http"
          path = "/metrics"
          interval = "10s"
          timeout = "2s"
        }
			}
		}
	}

}