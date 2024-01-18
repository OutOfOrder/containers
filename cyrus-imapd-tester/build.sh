#!/bin/sh

DATE=$(date +%Y%m%d)
podman build . -f podmanfile -t ghcr.io/outoforder/cyrus-imapd-tester:$DATE-00
podman image tag ghcr.io/outoforder/cyrus-imapd-tester:$DATE-00 ghcr.io/outoforder/cyrus-imapd-tester:latest
podman image tag ghcr.io/outoforder/cyrus-imapd-tester:latest docker.io/outoforder/cyrus-imapd-tester:$DATE-00
podman image tag ghcr.io/outoforder/cyrus-imapd-tester:latest docker.io/outoforder/cyrus-imapd-tester:latest


