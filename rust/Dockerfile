FROM rust:1.84-bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends pkg-config libssl-dev lldb \
    && rm -rf /var/lib/apt/lists/* \
    && rustup component add rustfmt clippy

WORKDIR /workspace
