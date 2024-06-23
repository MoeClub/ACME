#!/bin/bash

DOMAIN=()
DOMAIN+=("moeclub.org,*.moeclub.org")
# DOMAIN+=("sub.moeclub.org,*.sub.moeclub.org;moeclub.org")


execPath=`readlink -f "$0"`
execName=`basename "$execPath"`
[ "$1" == "1" ] && chmod 777 "$execPath" && sed -i "/${execName}/d;\$a\3 3 * * 1 root bash ${execPath} >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1

cd $(dirname "$execPath")
[ -f "./acme.py" ] || exit 1
[ -f "./acme/dv.acme-v02.api.pki.goog/acme.key" ] && s="google" || s="letsencrypt"

for domain in "${DOMAIN[@]}"; do
  _domain="${domain};"
  domain=`echo "${_domain}" |cut -d';' -f1`
  sub=`echo "${_domain}" |cut -d';' -f2`
  if [ "${s}" == "letsencrypt" ]; then
    python3 ./acme.py -s "${s}" -ecc -d "${domain}" -sub "${sub}"
  else
    python3 ./acme.py -s "${s}" -d "${domain}" -sub "${sub}"
  fi
done
