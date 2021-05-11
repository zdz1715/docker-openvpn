# docker-openvpn

## Usage
1.创建卷
```shell script
docker volume create --name openvpn
```
2.初始化(生成ca、服务端证书 10年有效期 + 服务端配置文件)
```shell script
docker run --rm -it -e EASYRSA_CA_EXPIRE=36500 -e EASYRSA_CERT_EXPIRE=3650 -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init --nopass
```
3.运行，推荐host模式，提高网络性能
```shell script
docker run --cap-add=NET_ADMIN --net=host --restart always -d -v openvpn:/etc/openvpn zdzserver/docker-openvpn
```
4.生成客户端（证书10年有效期）
```shell script
 docker run --rm -it -e EASYRSA_CERT_EXPIRE=3650 -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-client-conf -n user1 -r $REMOTE_IP --nopass
```
5.撤销客户端
```shell script
docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli revoke -n user1
```

## 证书管理
* 查看证书列表
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli list
```
* 撤销证书
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli revoke -n $NAME
```
* 证书续期
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli renew -n $NAME
```

## 定制服务端配置
* 初始化
```shell script
 docker run --rm -it -e EASYRSA_CA_EXPIRE=36500 -e EASYRSA_CERT_EXPIRE=3650 -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init --nopass -n $NAME -s $SERVER -p $PORT --set $line1 --set $line2 
```
> `-n`：证书名称，默认：vpn_server
> `-s`: 网段，默认 10.8.0.0/24
> `-p`: 端口，默认 1194
> `--nopass`: 不设置密码
> `--set`: 追加一行配置

* 初始化之后

再不更改根证书的情况下，可以生成新的服务端证书和配置,若证书名称不传或者和以前一样则不会重新生成证书

```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-server-conf -n $NAME -s $SERVER -p $PORT --set $line1 --set $line2
```

* 例子

```shell script
# 服务端
docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-server-conf --set 'push \"dhcp-option DNS 8.8.8.8\"' --set 'push \"dhcp-option DNS 114.114.114.114\"'
```



## vpn-cli
```shell script
 $ docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli --help
 
 Usage: vpn-cli COMMAND [OPTIONS]

    Options:
      -h, --help                    帮助
      -n, --name string             证书名称，服务端默认：vpn_server
      -p, --port int                端口，默认：1194
          --pair1 string            设置客户端IP
          --pair2 string            设置客户端IP
      -r, --remote string           设置客户端remote选项
      -s, --server string           内网地址范围，默认：10.8.0.0/24
          --set list                设置一行openvpn配置

    Commands:
      build-client-conf             生成客户端配置文件
      build-server-conf             生成服务端配置文件
      check                         检查能否正常运行
      init                          初始化，生成证书和服务端配置文件
      ip                            设置客户端ip
      list                          证书列表
      list-ip                       ip列表
      renew                         证书续期
      revoke                        撤销证书
      status                        客户端连接状态

```

## 客户端ip

* 设置客户端ip
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli ip -n user1 --pair1 10.8.1.8 --pair2 10.8.1.9
```

* ip列表
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli list-ip
```

### windows 客户端IP区间

[文档](https://openvpn.net/community-resources/configuring-client-specific-rules-and-access-policies/)

```
[  1,  2]   [  5,  6]   [  9, 10]   [ 13, 14]   [ 17, 18]
[ 21, 22]   [ 25, 26]   [ 29, 30]   [ 33, 34]   [ 37, 38]
[ 41, 42]   [ 45, 46]   [ 49, 50]   [ 53, 54]   [ 57, 58]
[ 61, 62]   [ 65, 66]   [ 69, 70]   [ 73, 74]   [ 77, 78]
[ 81, 82]   [ 85, 86]   [ 89, 90]   [ 93, 94]   [ 97, 98]
[101,102]   [105,106]   [109,110]   [113,114]   [117,118]
[121,122]   [125,126]   [129,130]   [133,134]   [137,138]
[141,142]   [145,146]   [149,150]   [153,154]   [157,158]
[161,162]   [165,166]   [169,170]   [173,174]   [177,178]
[181,182]   [185,186]   [189,190]   [193,194]   [197,198]
[201,202]   [205,206]   [209,210]   [213,214]   [217,218]
[221,222]   [225,226]   [229,230]   [233,234]   [237,238]
[241,242]   [245,246]   [249,250]   [253,254]
```
