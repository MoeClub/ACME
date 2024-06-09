# ACME

## acmeRenew.sh
```
# bash acmeRenew.sh <域名> <服务:证书路径> <证书下载服务器> <是否启用cron定时更新>

示例:
bash acmeRenew.sh moeclub.org nginx:/etc/nginx http://xxx.abc.com 1

# 从地址 http://xxx.abc.com/moeclub.org/server.crt.pem 下载证书
# 从地址 http://xxx.abc.com/moeclub.org/server.key.pem 下载密钥
# 将下载的证书和密钥储存至 /etc/nginx 目录内, 并重启 nginx 服务.
# 当服务器储存证书和本地一致时只下载为临时文件, 不替换证书不重启服务.
```







