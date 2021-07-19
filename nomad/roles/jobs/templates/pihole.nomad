job "pihole" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"
	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "dns" {
		count = 1
		restart {
			attempts = 5
			interval = "5m"
			delay    = "15s"
      mode     = "fail"
		}
		network {
			port "dns" { static = 53 }
			port "http" {
				to = 80
				static = 20080
			}
		}
		task "pihole" {
			driver = "docker"
			config {
				image = "pihole/pihole:v5.8.1"
				force_pull = true
				ports = [ "dns", "http"]
				cap_add = ["NET_ADMIN"]
				mount {
					type = "bind"
					target = "/etc/pihole/"
					source = "/etc/nomad/data/pihole/pihole/"
					readonly = false
				}
				mount {
					type = "bind"
					target = "/etc/dnsmasq.d/"
					source = "/etc/nomad/data/pihole/dnsmasq.d/"
					readonly = false
				}
			}
			env = {
				"TZ" = "America/Belem"
				"WEBPASSWORD" = "lucas12345"
			}
			resources {
				cpu    = 100
				memory = 128
			}
			service {
				name = "pihole-web"
				tags = ["urlprefix-/admin"]
				port = "http"
				check {
					name = "http port alive"
					type = "http"
					path = "/"
					interval = "10s"
					timeout = "2s"
				}
			}
		}
	}
}
