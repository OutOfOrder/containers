#!/bin/sh

DATE=$(date +%Y-%m-%d)
podman build --no-cache . -f Dockerfile -t docker.io/outoforder/rust-builder:rocky8-$DATE
RUSTC_VERSION=$(podman run --rm docker.io/outoforder/rust-builder:rocky8-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
podman image tag docker.io/outoforder/rust-builder:rocky8-$DATE docker.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
podman image tag docker.io/outoforder/rust-builder:rocky8-$DATE docker.io/outoforder/rust-builder:latest

