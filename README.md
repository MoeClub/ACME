# ACME

## acmeAuto.sh
```
示例
bash acmeAuto.sh

# 调用 acme.py 签发脚本内指定域名的证书.
# 如果有 GTS 授权, 优先签发 GTS 证书. 否则签发匿名的 letsencrypt 证书.
# 域名采用数组模式. 一行一组域名, 域名间用逗号分隔.
# 如果要签发的是子域名, 请在最后添加主域名并用分号分隔.
# 自行添加 /etc/crontab 命令实现自动更新证书.
```

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







