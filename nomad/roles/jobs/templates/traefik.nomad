job "traefik" {
  region = "global"
  datacenters = ["dc1"]
  type = "system"
  update {
    max_parallel = 1
    stagger      = "1m"
    auto_revert = true
  }
  group "traefik" {
    count = 1
    network {
      port "http" { static = 80 }
      port "https" { static = 443 }
      port "traefik" { static = 8081 }
    }
    service {
      name = "traefik"
      port = "http"
      tags = [
      "traefik.enable=true"
      ]
      check {
        name = "Traefik healthcheck"
        type = "tcp"
        port = "traefik"
        path = "/ping"
        interval = "10s"
        timeout = "2s"
      }
    }
    task "traefik" {
      driver = "docker"
      config {
        image = "traefik:v2.4.11"
        volumes = [ "local/traefik.yaml:/etc/traefik/traefik.yaml" ]
        ports = ["http", "https", "traefik"]
      }
      resources {
        cpu    = 100
        memory = 128
      }
      template {
        destination = "local/traefik.yaml"
        data = <<EOH
entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"
  traefik:
    address: ":8081"
ping:
  entryPoint: "traefik"
accessLog: {}
metrics:
  prometheus:
    entryPoint: "traefik"
log:
  level: "DEBUG"
  format = "json"
api:
    dashboard: true
    insecure: true
providers:
  consulCatalog:
    prefix: "traefik"
    exposedByDefault: false
    endpoint:
      address: "http://192.168.0.30:8500"
EOH
      }
    }
  }
}
