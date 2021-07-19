job "cadvisor" {
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
			port "http" { to = 8080 }
		}
		task "cadvisor" {
			driver = "docker"
			config {
				image = "zcube/cadvisor:v0.37.5"
				force_pull = true
				ports = ["http"]
				volumes = [
          "/:/rootfs:ro",
          "/var/run:/var/run:rw",
          "/sys:/sys:ro",
          "/var/lib/docker/:/var/lib/docker:ro",
          "/cgroup:/cgroup:ro"
        ]
        logging {
          type = "journald"
          config {
            tag = "CADVISOR"
          }
        }
			}
			resources {
				cpu = 50
				memory = 100
			}
			service {
				name = "cadvisor"
				tags = ["metrics", "monitoring"]
				// address_mode = "driver"
				port = "http"
				check {
					name = "cadvisor port alive"
					type = "http"
					path = "/metrics/"
					interval = "10s"
					timeout = "2s"
				}
			}
		}
	}
}