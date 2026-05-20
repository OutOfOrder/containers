#!/bin/sh

DATE=$(date +%Y%m%d)
podman build . --format docker -f Containerfile -t docker.io/outoforder/smtp-relay:$DATE

podman image tag docker.io/outoforder/smtp-relay:$DATE docker.io/outoforder/smtp-relay:latest


