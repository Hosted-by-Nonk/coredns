# coredns

A [CoreDNS](https://coredns.io) Docker image with a built-in `curl` healthcheck.

## Usage

First of all, you'll need to add a `health :port` line to your `Corefile`, or else the healthcheck will always fail:

```conf
. {
    health :8081
}
```

The default behavior is to ping the healthcheck endpoint at the local port `8081`, but you can customize the port by setting the `HEALTHCHECK_PORT` environment variable, e.g. in docker-compose:

```yaml
services:
  coredns:
    image: ghcr.io/hosted-by-nonk/coredns
    container_name: coredns
    restart: always
    networks: [default, caddy]
    ports: [53:53/tcp, 53:53/udp]
    environment:
      HEALTHCHECK_PORT: 9999
```
