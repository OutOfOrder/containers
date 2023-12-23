FROM rockylinux:8-minimal

RUN microdnf install -y sscg postfix cyrus-sasl-plain net-tools \
    && microdnf clean all \
    && rm -f /etc/pki/tls/private/postfix.key /etc/pki/tls/certs/postfix.pem \
    && rm -rf /usr/share/{doc,man}

RUN postconf \
    smtpd_relay_restrictions=reject_unauth_destination,permit_sasl_authenticated,permit_mynetworks,reject \
    smtp_tls_CAfile=/etc/pki/postfix/postfix-ca.pem \
    smtpd_tls_key_file=/etc/pki/postfix/postfix-key.pem \
    smtpd_tls_cert_file=/etc/pki/postfix/postfix.pem \
    'smtp_tls_session_cache_database=btree:${data_directory}/smtp_scache' \
    smtp_use_tls=yes \
    maillog_file=/dev/stdout \
    'myorigin=$mydomain'

COPY --chmod=755 entrypoint.sh /usr/local/sbin/

ENV RELAY_MYDOMAIN=domain.com
ENV RELAY_MYNETWORKS=127.0.0.0/8
ENV RELAY_HOST=[127.0.0.1]:25
ENV RELAY_DOMAINS=\$mydomain
ENV RELAY_MODE=STRICT
ENV RELAY_USE_TLS=yes
ENV RELAY_TLS_VERIFY=may
ENV RELAY_TLS_CA=/etc/pki/postfix/postfix-ca.pem

ENV POSTCONF_inet_interfaces all
ENV POSTCONF_inet_protocols all

EXPOSE 25

HEALTHCHECK --interval=5s --retries=10 CMD netstat -ltn | grep -c :587 || exit 1

CMD /usr/local/sbin/entrypoint.sh

LABEL org.opencontainers.image.source https://github.com/OutOfOrder/containers/smtp-relay
LABEL org.opencontainers.image.description "Sets up a postfix mail relay"

