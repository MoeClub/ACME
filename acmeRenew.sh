#!/bin/bash

crtDomain="${1:-}"
crtSeviceRoot="${2:-nginx:/etc/nginx/crt}"
crtServer="${3:-http://crt.libmk.com}"
crtCron="${4:-0}"
crtServiceName=`echo "${crtSeviceRoot}" |cut -d':' -f1`
crtRoot=`echo "${crtSeviceRoot}" |cut -d':' -f2`


[ "${crtCron}" != "0" ] && execPath="/usr/local/bin/acmeRenew.sh" && cp -rf "$0" "$execPath" && chmod 777 "$execPath" && sed -i "/${crtDomain}/d;\$a\25 4 * * 1 root bash ${execPath} ${crtDomain} ${crtRoot} ${crtServer} >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1


[ -n "${crtDomain}" ] && [ -n "${crtRoot}" ] && [ -n "${crtServer}" ] || exit 1
[ -d "${crtRoot%/}/${crtDomain%/}" ] || mkdir -p "${crtRoot%/}/${crtDomain%/}"


wget -qO "/tmp/_crt_server.crt.pem" "${crtServer%/}/${crtDomain%/}/server.crt.pem";
[ "$?" -eq "0" ] || exit 1
crtMd5=`openssl x509 -in "/tmp/_crt_server.crt.pem" -pubkey -noout -outform pem 2>/dev/null |openssl md5 2>/dev/null |cut -d'=' -f2 |grep -o '[0-9a-z]*'`
[ -n "${crtMd5}" ] || exit 1
wget -qO "/tmp/_key_server.key.pem" "${crtServer%/}/${crtDomain%/}/server.key.pem";
[ "$?" -eq "0" ] || exit 1
keyMd5=`openssl pkey -in "/tmp/_key_server.key.pem" -pubout -outform pem 2>/dev/null |openssl md5 2>/dev/null |cut -d'=' -f2 |grep -o '[0-9a-z]*'`
[ -n "${keyMd5}" ] || exit 1
[ -n "${crtMd5}" ] && [ -n "${keyMd5}" ] && [ "${crtMd5}" == "${keyMd5}"  ] || exit 1
[ -f "/tmp/_crt_server.crt.pem" ] && [ -f "/tmp/_key_server.key.pem" ] || exit 1
cp -rf "/tmp/_crt_server.crt.pem" "${crtRoot%/}/${crtDomain%/}/server.crt.pem"
cp -rf "/tmp/_key_server.key.pem" "${crtRoot%/}/${crtDomain%/}/server.key.pem"
rm -rf "/tmp/_crt_server.crt.pem" "/tmp/_key_server.key.pem"

for serviceName in "${crtServiceName[@]}"; do systemctl restart "${serviceName}" 2>/dev/null; done

