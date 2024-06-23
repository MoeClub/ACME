#!/bin/bash

crtDomain="${1:-}"
crtSeviceRoot="${2:-nginx:/etc/nginx}"
crtServer="${3:-http://crt.libmk.com}"
crtCron="${4:-0}"
crtServiceName=`echo "${crtSeviceRoot}" |cut -d':' -f1`
crtRoot=`echo "${crtSeviceRoot}" |cut -d':' -f2`

crtTarget="${crtRoot%/}"
# crtTarget="${crtRoot%/}/${crtDomain%/}"

[ -n "${crtDomain}" ] && [ -n "${crtRoot}" ] && [ -n "${crtServer}" ] || exit 1
[ "${crtCron}" != "0" ] && execPath="/usr/local/bin/acmeRenew.sh" && cat "$0" >"$execPath" && chmod 777 "$execPath" && sed -i "/${crtDomain}/d;\$a\25 4 * * 1 root bash ${execPath} ${crtDomain} ${crtSeviceRoot} ${crtServer} >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1


crt="$(mktemp)"
key="$(mktemp)"
rm -rf ${crt} ${key}
trap "rm -rf ${crt} ${key}" EXIT

checkMd5() {
  crtMode="${1:-}"
  crtPath="${2:-}"
  [ -n "$crtMode" ] && [ -n "$crtPath" ] && [ -f "$crtPath" ] || return
  [ "$crtMode" == "crt" ] && crtMd5=`openssl x509 -in "${crtPath}" -pubkey -noout -outform pem 2>/dev/null |openssl md5 2>/dev/null |cut -d'=' -f2 |grep -o '[0-9a-z]*'`
  [ "$crtMode" == "key" ] && crtMd5=`openssl pkey -in "${crtPath}" -pubout -outform pem 2>/dev/null |openssl md5 2>/dev/null |cut -d'=' -f2 |grep -o '[0-9a-z]*'`
  echo -ne "$crtMd5"
}

# check local crt
localMd5=`checkMd5 crt "${crtTarget%/}/server.crt.pem"`
# download crt
wget -qO "${crt}" "${crtServer%/}/${crtDomain%/}/server.crt.pem";
[ "$?" -eq "0" ] || exit 1
crtMd5=`checkMd5 crt "${crt}"`
[ -n "${crtMd5}" ] || exit 1
[ -n "${localMd5}" ] && [ "${localMd5}" == "${crtMd5}" ] && exit 0
# download key
wget -qO "${key}" "${crtServer%/}/${crtDomain%/}/server.key.pem";
[ "$?" -eq "0" ] || exit 1
keyMd5=`checkMd5 key "${key}"`
[ -n "${keyMd5}" ] || exit 1
[ -n "${crtMd5}" ] && [ -n "${keyMd5}" ] && [ "${crtMd5}" == "${keyMd5}"  ] || exit 1
[ -f "${crt}" ] && [ -f "${key}" ] || exit 1
# target
[ -d "${crtTarget%/}" ] || mkdir -p "${crtTarget%/}"
cp -rf "${crt}" "${crtTarget%/}/server.crt.pem"
cp -rf "${key}" "${crtTarget%/}/server.key.pem"

# restart service
systemctl restart "${crtServiceName}" 2>/dev/null
