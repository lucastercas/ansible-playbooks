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
      port "http" { static = 8080 }
      port "api" { static = 8081 }
    }
    service {
      name = "traefik"
      check {
        name = "Traefik healthcheck"
        type = "tcp"
        port = "http"
        interval = "10s"
        timeout = "2s"
      }
    }
    task "traefik" {
      driver = "docker"
      config {
        image = "traefik:v2.4.11"
        network_mode = "host"
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
        ]
        args = [
        ]
      }
      resources {
        cpu    = 100
        memory = 128
      }
      template {
        data = <<EOH
entryPoints:
  http:
    address: ":8080"
  traefik:
    address: ":8081"
  https:
    address: ":443"
ping:
  entryPoint: "http"
accessLog: {}
metrics:
  prometheus:
    entryPoint: "http"
log:
  level: DEBUG
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
        destination = "local/traefik.yaml"
      }
    }
  }
}