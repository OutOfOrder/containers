#!/bin/sh

DATE=$(date +%Y%m%d)
podman build . -f Containerfile -t docker.io/outoforder/cyrus-imapd-tester:$DATE-00
podman image tag docker.io/outoforder/cyrus-imapd-tester:$DATE-00 docker.io/outoforder/cyrus-imapd-tester:latest


