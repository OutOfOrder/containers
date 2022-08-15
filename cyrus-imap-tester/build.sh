#!/bin/sh

DATE=$(date +%Y%m%d)
docker build . -f Dockerfile -t outoforder/cyrus-imapd-tester:$DATE-00
docker image tag outoforder/cyrus-imapd-tester:$DATE-00 outoforder/cyrus-imapd-tester:latest


