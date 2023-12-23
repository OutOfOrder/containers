#!/bin/sh

set -e

if [ ! -f /etc/pki/postfix/postfix.pem ]; then
  mkdir -p /etc/pki/postfix
  echo "--- Generating Postfix Certificates (in /etc/pki/postfix)"
  sscg --package postfix \
    --cert-file /etc/pki/postfix/postfix.pem \
    --cert-key-file /etc/pki/postfix/postfix-key.pem \
    --ca-file /etc/pki/postfix/postfix-ca.pem \
    --cert-key-mode=0640
  rm /dhparams.pem
  echo "--- Finished generating certificates"
fi

echo 'Settings postfix using postconf variables from environment...'
env | grep '^POSTCONF_' \
    | cut -d _ -f 2- \
    | xargs -r -n 1 -I % postconf '%'

echo 'Settings postfix...'
postconf \
    "mydomain=${RELAY_MYDOMAIN}" \
    "mynetworks=${RELAY_MYNETWORKS}" \
    "relayhost=${RELAY_HOST}" \
    "relay_domains=${RELAY_DOMAINS}"

# Static restrictions for smtp clients
if [ "${RELAY_MODE}" = 'STRICT' ]; then
  # set STRICT mode
  # no one can send mail to another domain than the relay domains list
  # only network/sasl authenticated user can send mail through relay
  postconf 'smtpd_relay_restrictions=reject_unauth_destination,permit_sasl_authenticated,permit_mynetworks,reject'
elif [ "${RELAY_MODE}" = 'ALLOW_SASLAUTH_NODOMAIN' ]; then
  # set ALLOW_SASLAUTH_NODOMAIN mode
  # only authenticated smtp users can send email to another domain than the relay domains list
  postconf 'smtpd_relay_restrictions=permit_sasl_authenticated,reject_unauth_destination,permit_mynetworks,reject'
elif [ "${RELAY_MODE}" = 'ALLOW_NETAUTH_NODOMAIN' ]; then
  # set ALLOW_NETAUTH_NODOMAIN mode
  # only authenticated smtp users can send email to another domain than the relay domains list
  postconf 'smtpd_relay_restrictions=permit_mynetworks,reject_unauth_destination,permit_sasl_authenticated,reject'
elif [ "${RELAY_MODE}" = 'ALLOW_AUTH_NODOMAIN' ]; then
  # set ALLOW_AUTH_NODOMAIN mode
  # no one can send mail to another domain than the relay domains list
  # only network/sasl authenticated user can send mail through relay
  postconf 'smtpd_relay_restrictions=permit_sasl_authenticated,permit_mynetworks,reject'
else
  # set the content of the mode into the restrictions
  postconf "smtpd_relay_restrictions=${RELAY_MODE}"
fi

# Set hostname
if [ -n "${RELAY_MYHOSTNAME}" ]; then
  postconf "myhostname=${RELAY_MYHOSTNAME}"
fi

/usr/libexec/postfix/aliasesdb
/usr/libexec/postfix/chroot-update

# Configure authentification to relay if needed
if [ -n "${RELAY_LOGIN}" ] && [ -n "${RELAY_PASSWORD}" ] || [ -f /etc/postfix/sasl_passwd ]; then
  postconf 'smtp_sasl_auth_enable=yes'

  if [ -n "${RELAY_LOGIN}" ] && [ -n "${RELAY_PASSWORD}" ]; then
    # use static database using environment vars
    postconf "smtp_sasl_password_maps=inline:{${RELAY_HOST}=${RELAY_LOGIN}:${RELAY_PASSWORD}}"
  else
     # use password from hash database
    postconf 'smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd'
    postmap /etc/postfix/sasl_passwd
  fi
  postconf 'smtp_sasl_security_options=noanonymous'

  if [ "${RELAY_USE_TLS}" = 'yes' ]; then
    if [ -z "${RELAY_TLS_CA}" ]; then
      echo "you must fill RELAY_TLS_CA with the path to the CA file in the container" >&2
      exit 1
    fi
    if [ ! -f "${RELAY_TLS_CA}" ] || [ ! -r "${RELAY_TLS_CA}" ]; then
      echo "The file at RELAY_TLS_CA must exists and be a valid file" >&2
      exit 1
    fi
    postconf "smtp_tls_CAfile=${RELAY_TLS_CA}"
  fi
  postconf "smtp_tls_security_level=${RELAY_TLS_VERIFY}"
  # shellcheck disable=SC2016
  postconf 'smtp_tls_session_cache_database=btree:${data_directory}/smtp_scache'
  postconf "smtp_use_tls=${RELAY_USE_TLS}"
fi


/usr/sbin/postfix start-fg

