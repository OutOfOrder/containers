#!/bin/sh

DATE=$(date +%Y%m%d)
docker build . -f Dockerfile -t ghcr.io/outoforder/cyrus-imapd-tester:$DATE-00
docker image tag ghcr.io/outoforder/cyrus-imapd-tester:$DATE-00 ghcr.io/outoforder/cyrus-imapd-tester:latest
docker image tag ghcr.io/outoforder/cyrus-imapd-tester:latest outoforder/cyrus-imapd-tester:$DATE-00


