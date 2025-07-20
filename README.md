# coredns

A [CoreDNS](https://coredns.io) Docker image with a built-in `curl` healthcheck.

> [!WARNING]
> The healthcheck port is hardcoded to `8081`

You'll need to add a `health :8081` line to your `Corefile`, or else the healthcheck will always fail:

```conf
. {
    health :8081
}
```
