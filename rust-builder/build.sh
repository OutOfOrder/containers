#!/bin/sh

DATE=$(date +%Y-%m-%d)
docker build --no-cache . -f Dockerfile -t outoforder/rust-builder:rocky8-$DATE
RUSTC_VERSION=$(docker run --rm outoforder/rust-builder:rocky8-$DATE rustc --version | sed 's/rustc \([[:digit:].]*\).*/\1/g')
docker image tag outoforder/rust-builder:rocky8-$DATE outoforder/rust-builder:rocky8-$RUSTC_VERSION
docker image tag outoforder/rust-builder:rocky8-$DATE outoforder/rust-builder:latest
