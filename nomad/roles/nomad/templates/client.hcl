data_dir  = "/etc/nomad/conf"
log_level = "DEBUG"
enable_syslog = "true"
bind_addr = "0.0.0.0"

client {
  enabled = true
  network_interface = "wlan0"
  servers = [
    "192.168.0.24:4647"
  ]
  host_volume "pihole_data" {
    path = "/etc/nomad/data/pihole"
    read_only = false
  }
}

plugin "docker" {
	config {
		allow_privileged = true
		allow_caps = ["ALL"]
	}
}

