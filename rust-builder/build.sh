#!/bin/sh

DATE=$(date +%Y-%m-%d)
docker build --no-cache . -f Dockerfile -t ghcr.io/outoforder/rust-builder:rocky8-$DATE
RUSTC_VERSION=$(docker run --rm ghcr.io/outoforder/rust-builder:rocky8-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
docker image tag ghcr.io/outoforder/rust-builder:rocky8-$DATE ghcr.io/outoforder/rust-builder:rocky8-$RUSTC_VERSION
docker image tag ghcr.io/outoforder/rust-builder:rocky8-$DATE ghcr.io/outoforder/rust-builder:latest
