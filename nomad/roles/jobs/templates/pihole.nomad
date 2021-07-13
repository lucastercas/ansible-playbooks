job "pihole_no_volume" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"
	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "svc" {
		count = 1
		restart {
			interval = "5m"
			attempts = 5
			delay    = "15s"
		}
		network {
			port "dns" { static = 53 }
			port "http" { to = 80}
		}
		task "app" {
			driver = "docker"
			config {
				network_mode = "bridge"
				image = "pihole/pihole:v5.8.1"
				ports = [ "dns", "http"]
				cap_add = ["NET_ADMIN"]
			}
			env = {
				"TZ" = "America/Belem"
				"WEBPASSWORD" = "lucas123"
			}
			resources {
				cpu    = 200
				memory = 128
			}
			service {
				name = "pihole-gui"
				port = "http"
			}
		}

	}

}
