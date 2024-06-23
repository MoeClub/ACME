# ACME

## 安装依赖
```
apt install -y python3-pip python3-cryptography python3-aiohttp
pip3 install aiohttp_socks

```

## acme.py
```
# 签发新证书
python3 acme.py -d "xxx.com,*.xxx.com"
python3 acme.py -d "sub.xxx.com,*.sub.xxx.com" -v dns -s google -sub "xxx.com" -ecc

# 注册授权
python3 acme.py -register -s google -mail "xyz@abc.com" -kid "<keyId>" -key "<hmacKey>"

# 华为DNS自动验证, 否则手动 DNS 验证. 也可自行修改源码.
# 修改 acme.py 文件第 587 行最后的部分 **{"key": None, "secret": None}
# 将两个 None 换成你自己的华为DNS密钥即可自动验证DNS.
```

## acmeAuto.sh
```
示例
bash acmeAuto.sh

# 调用 acme.py 签发脚本内指定域名的证书.
# 如果有 GTS 授权, 优先签发 GTS 证书. 否则签发匿名的 letsencrypt 证书.
# 域名采用数组模式. 一行一组域名, 域名间用逗号分隔.
# 如果要签发的是子域名, 请在最后添加主域名并用分号分隔.

bash acmeAuto.sh 1
# 利用系统 cron 实现自动运行(默认每星期三凌晨3点3分)
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
# 最后参数为 1 表示启动cron定时更新, 默认为每个星期一的凌晨四点二十五分执行更新检查.
```

## GTS 授权
```
# 登录谷歌账户, 打开网址点击 Enable 按钮 (无需GCP账号,只需要能够访问谷歌的账户创建项目)
https://console.cloud.google.com/apis/library/publicca.googleapis.com
# 点开右上角的命令图标打开 Cloud Shell, 输入创建密钥命令
gcloud publicca external-account-keys create
# 使用 acme.py 进行授权后即可签发 GTS 证书
python3 acme.py -register -s google -mail "xyz@abc.com" -kid "<keyId>" -key "<hmacKey>"


# 选择GCP项目<可选>
gcloud config set project <project-name>
# 打开API权限<可选>
gcloud services enable publicca.googleapis.com

```







