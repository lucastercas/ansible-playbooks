server {
  enabled = true
	bootstrap_expect = 1
	server_join {
		retry_join = [
			{% for host in groups.servers %}
			"{{ hostvars[host].ansible_host }}:4647"
			{% endfor %}
		]
	}
}
