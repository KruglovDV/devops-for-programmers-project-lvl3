data "digitalocean_ssh_key" "devops" {
  name = "devops"
}

resource "digitalocean_droplet" "web" {
  count    = 2
  image    = "docker-20-04"
  name     = format("project-%02d", count.index + 1)
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.devops.id]
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 5000
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 5000
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = 5000
    protocol = "http"
    path     = "/"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}

resource "digitalocean_domain" "default" {
  name = "somedomain.club"
}

resource "digitalocean_certificate" "cert" {
  name    = "project-cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.default.name]
}

output "ip_addresses" {
  value = digitalocean_droplet.web.*.ipv4_address
}

resource "datadog_monitor" "healthcheck" {
  name    = "Alert!!! {{host.name}}"
  type    = "service check"
  query   = "\"http.can_connect\".over(\"*\",\"instance:health_check_status\").by(\"host\",\"instance\",\"url\").last(2).count_by_status()"
  message = "Alert, alert! @kruglov081289@gmail.com"
}
