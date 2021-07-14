job "fabio" {
	region = "global"
  datacenters = ["dc1"]
  type = "system"

  group "fabio" {
		network {
			port "lb" {
				static = 9999
			}
			port "ui" {
				static = 9998
			}
		}
    task "fabio" {
      driver = "docker"
      config {
        image = "lucastercas/fabio:arm64_0.1.0"
        network_mode = "host"
      }
			env {
				FABIO_registry_consul_addr = "192.168.0.30:8500"
			}

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
