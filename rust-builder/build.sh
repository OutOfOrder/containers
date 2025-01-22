#!/bin/sh

set -e

DATE=$(date +%Y-%m-%d)
podman build --no-cache . -f Containerfile.rocky8 -t docker.io/outoforder/rust-builder:rocky8-$DATE
RUSTC_VERSION=$(podman run --rm docker.io/outoforder/rust-builder:rocky8-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
podman image tag docker.io/outoforder/rust-builder:rocky8-$DATE docker.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
podman image tag docker.io/outoforder/rust-builder:rocky8-$DATE docker.io/outoforder/rust-builder:rocky8-latest
podman image tag docker.io/outoforder/rust-builder:rocky8-$DATE docker.io/outoforder/rust-builder:latest

podman image push docker.io/outoforder/rust-builder:rocky8-$DATE
podman image push docker.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
podman image push docker.io/outoforder/rust-builder:rocky8-latest
podman image push docker.io/outoforder/rust-builder:latest

podman build --no-cache . -f Containerfile.rocky9 -t docker.io/outoforder/rust-builder:rocky9-$DATE
RUSTC_VERSION=$(podman run --rm docker.io/outoforder/rust-builder:rocky9-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
podman image tag docker.io/outoforder/rust-builder:rocky9-$DATE docker.io/outoforder/rust-builder:rocky9-$RUSTC_VERSION
podman image tag docker.io/outoforder/rust-builder:rocky9-$DATE docker.io/outoforder/rust-builder:rocky9-latest

podman image push docker.io/outoforder/rust-builder:rocky9-$DATE
podman image push docker.io/outoforder/rust-builder:rocky9-$RUSTC_VERSION
podman image push docker.io/outoforder/rust-builder:rocky9-latest

