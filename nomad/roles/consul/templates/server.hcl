node_name = "consul-{{ inventory_hostname }}"
// region = "global"
datacenter = "dc1"

data_dir = "/etc/consul/data"
log_level = "DEBUG"
enable_syslog = true
enable_debug = true
enable_central_service_config = true

server = true
bootstrap = true
bootstrap_expect = 1
ui = true

retry_join = [
	"192.168.0.30"
]

bind_addr = "0.0.0.0"
advertise_addr = "192.168.0.30"
client_addr = "0.0.0.0"
ports {
	http = 8500
	grpc = 8502
}
addresses {
	http = "0.0.0.0"
}

connect {
	enabled = true
}

telemetry {
  // dogstatsd_addr = "localhost:8125"
	prometheus_retention_time = "5s"
}

acl {
	enabled = false
}