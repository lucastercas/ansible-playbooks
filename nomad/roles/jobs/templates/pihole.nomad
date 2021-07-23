job "pihole" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"
	update {
		max_parallel = 1
		stagger = "10s"
		auto_revert = true
	}
	group "pihole" {
		count = 1
		restart {
			attempts = 5
			interval = "5m"
			delay    = "15s"
      mode     = "fail"
		}
		network {
			port "dns" {
        to = 53
        static = 53
      }
			port "http" { to = 80 }
		}
		service {
			name = "pihole-web"
			tags = [
				"dns",
				"traefik.enable=true",
				"traefik.http.routers.pihole.rule=PathPrefix(`/admin`)",
			]
			port = "http"
			check {
				name = "Pihole healthcheck"
				type = "http"
				path = "/"
				interval = "10s"
				timeout = "2s"
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
		}
	}
}
