#!/bin/sh

DATE=$(date +%Y-%m-%d)
podman build --no-cache . -f Dockerfile -t ghcr.io/outoforder/rust-builder:rocky8-$DATE
RUSTC_VERSION=$(podman run --rm ghcr.io/outoforder/rust-builder:rocky8-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
podman image tag ghcr.io/outoforder/rust-builder:rocky8-$DATE ghcr.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
podman image tag ghcr.io/outoforder/rust-builder:rocky8-$DATE ghcr.io/outoforder/rust-builder:latest
podman image tag ghcr.io/outoforder/rust-builder:latest docker.io/outoforder/rust-builder:rocky8-$DATE
podman image tag ghcr.io/outoforder/rust-builder:latest docker.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
podman image tag ghcr.io/outoforder/rust-builder:latest docker.io/outoforder/rust-builder:latest

