FROM rockylinux:8-minimal

RUN microdnf -y install libpq-devel gcc && microdnf clean all
ENV HOME=/home/rust \
    PATH=/home/rust/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal -c clippy rustfmt

WORKDIR /home/rust/src

LABEL org.opencontainers.image.source https://github.com/OutOfOrder/containers/rust-builder
LABEL org.opencontainers.image.description "Image for building rust applications based on Rocky Linux 8"
