FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        cmake \
        ninja-build \
        clang-format \
        clang-tidy \
        clangd \
        gdb \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
