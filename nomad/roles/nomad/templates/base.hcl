name = "nomad-{{ inventory_hostname }}"
region = "global"
datacenter = "dc1"

data_dir  = "/etc/nomad/conf"
log_level = "DEBUG"
enable_syslog = true
enable_debug = true

bind_addr = "{{ hostvars[inventory_hostname].ansible_host }}"
ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}
advertise {
  http = "{{ hostvars[inventory_hostname].ansible_host }}"
  rpc  = "{{ hostvars[inventory_hostname].ansible_host }}"
  serf = "{{ hostvars[inventory_hostname].ansible_host }}"
}

{% if use_consul %}
consul {
	address = "{{ hostvars[groups.consul[0]].ansible_host }}:8500"
	auto_advertise = true
	server_auto_join = true
	client_auto_join = true
}
{% endif %}

acl {
  enabled    = false
  token_ttl  = "30s"
  policy_ttl = "60s"
}

telemetry {
  collection_interval = "5s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}

plugin "docker" {
	config {
		allow_privileged = true
		allow_caps = ["ALL"]
    extra_labels = ["job_name", "task_group_name", "task_name", "namespace", "node_name"]
    volumes {
      enabled = true
    }
	}
}
