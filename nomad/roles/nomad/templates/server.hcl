data_dir  = "/etc/nomad/conf"
log_level = "DEBUG"
enable_syslog = "true"
bind_addr = "0.0.0.0"

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

server {
  enabled = true
	bootstrap_expect = 1
	server_join {
		retry_join = [
			"192.168.0.24:4648"
		]
	}
}

consul {
	address = "127.0.0.1:8500
}

acl {
  enabled    = false
  token_ttl  = "30s"
  policy_ttl = "60s"
}