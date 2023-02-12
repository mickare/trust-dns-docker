[![Docker Build](https://github.com/mickare/trust-dns-docker/actions/workflows/docker-build-and-publish.yaml/badge.svg)](https://github.com/mickare/trust-dns-docker/actions/workflows/docker-build-and-publish.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE-MIT)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](LICENSE-APACHE)

# Trust-DNS in Docker


The Rust based DNS server [Trust-DNS](https://github.com/bluejekyll/trust-dns) installed in a Docker image.

> **This is not the official Docker image!**
>
> Please follow or give a star to the official repository and authors: https://github.com/bluejekyll/trust-dns

## Usage

```console
docker run -p 53:53 mickare/trust-dns
```

### Repositories
- `docker.io/mickare/trust-dns` ([link](https://hub.docker.com/r/mickare/trust-dns))
- `ghcr.io/mickare/trust-dns-docker` ([link](https://github.com/mickare/trust-dns-docker/pkgs/container/trust-dns-docker))

## Configuration

### Default configuration
The Docker image is pre-configured as a forwarding DNS server via **DNS-over-HTTPS (DoH)** with the following DNS providers:
- `1dot1dot1dot1.cloudflare-dns.com`
- `dns.quad9.net`
- `dns.google`

### Custom `config.toml`

You can create your own [Trust-DNS](https://github.com/bluejekyll/trust-dns) configuration.
Please read the [Trust-DNS documentation](https://github.com/bluejekyll/trust-dns/blob/main/README.md) or take a look at the [examples](https://github.com/bluejekyll/trust-dns/blob/main/tests/test-data/test_configs/example.toml).

**Example `config.toml`**
```toml
[[zones]]
zone = "."
zone_type = "Forward"
stores = { type = "forward", name_servers = [
    # { socket_addr = "1.1.1.1:53", protocol = "udp", trust_nx_responses = false },
    # { socket_addr = "1.0.0.1:53", protocol = "tcp", trust_nx_responses = false },
] }
```

**Example `docker-compose.yaml`**
```yaml
ersion: "3.7"

services:
  caddy:
    image: mickare/trust-dns:<version>
    restart: unless-stopped
    ports:
      - "53:53"
    volumes:
      - ./config.toml:/etc/trust-dns/config.toml:ro
```

### Environment variables

| Name             | Default | Description
|------------------|---------|-------------------------
| `RUST_LOG`       | `info`  | Logging verbosity ([docu](https://docs.rs/tracing-subscriber/0.3.16/tracing_subscriber/fmt/index.html#filtering-events-with-environment-variables))

### Ports

| Port  | Protocol     | Description
|-------|--------------|----------------
| `53`  | `udp`, `tcp` | Required for DNS over UDP (Do53) or TCP (Do53/TCP)
| `853` | `tcp`        | Required for DNS over TLS (DOT)
| `443` | `tcp`        | Required for DNS over HTTPS (DoH)

## License

Licensed under either of

- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or <https://www.apache.org/licenses/LICENSE-2.0>)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or <https://opensource.org/licenses/MIT>)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.