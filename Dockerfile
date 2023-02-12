# Copyright 2023 Michael Käser <info@mickare.de>
#
# Licensed under the Apache License, Version 2.0, <LICENSE-APACHE or
# http://apache.org/licenses/LICENSE-2.0> or the MIT license <LICENSE-MIT or
# http://opensource.org/licenses/MIT>, at your option. This file may not be
# copied, modified, or distributed except according to those terms.

# syntax=docker/dockerfile:1
ARG TRUST_DNS_VERSION

FROM rust:1.67-bookworm as builder
ARG TRUST_DNS_VERSION
RUN apt-get update && apt-get install -y \
    openssl \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*
RUN cargo install trust-dns --bins \
    --version "${TRUST_DNS_VERSION}" \
    --features "dns-over-rustls,dns-over-https-rustls"


FROM debian:bookworm-slim
ARG TRUST_DNS_VERSION
ENV TRUST_DNS_VERSION="${TRUST_DNS_VERSION}" \
    RUST_LOG=info
RUN apt-get update && apt-get install -y \
    openssl libssl-dev pkg-config
# Rename binary "named" to "trust-dns"
COPY --from=builder /usr/local/cargo/bin/named /usr/local/bin/trust-dns
COPY config.toml /etc/trust-dns/config.toml
COPY default/ /etc/trust-dns/default
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 853/tcp
EXPOSE 443/tcp
WORKDIR /root
CMD trust-dns --config /etc/trust-dns/config.toml
