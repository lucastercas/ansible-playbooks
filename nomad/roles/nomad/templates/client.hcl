client {
  enabled = true
  network_interface = "wlan0"
  servers = [
    {% for host in groups.servers %}
    "{{ hostvars[host].ansible_host }}:4647"
    {% endfor %}
  ]
  host_volume "pihole_data" {
    path = "/etc/nomad/data/pihole"
    read_only = false
  }
}
