# docker-openvpn

## Usage
1.创建卷
```shell script
docker volume create --name openvpn
```
2.初始化
```shell script
docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init --nopass
```
3.运行，推荐host模式，提高网络性能
```shell script
docker run --net=host -d --privileged --restart always -v openvpn:/etc/openvpn zdzserver/docker-openvpn
```
4.生成客户端
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-client-conf -n user1 -r $REMOTE_IP --nopass
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
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init --nopass -n $NAME -s $SERVER -p $PORT --push "route 10.171.48.0 255.255.248.0" --push="route 0.0.0.0 0.0.0.0"
```
* 初始化之后

再不更改根证书的情况下，可以生成新的服务端证书和配置,若证书名称不传或者和以前一样则不会重新生成证书

```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-server-conf -n $NAME -s $SERVER -p $PORT --push "route 10.171.48.0 255.255.248.0" --push="route 0.0.0.0 0.0.0.0"
```

## 证书有效期
* 修改CA证书有效期（默认：3650天）
```shell script
docker run -env EASYRSA_CA_EXPIRE=36500 --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init ...
```
* 修改服务端证书有效期（默认：1080天）
```shell script
docker run -env EASYRSA_CERT_EXPIRE=3650 --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-server-conf ...
```

* 修改客户端证书有效期（默认：1080天）
```shell script
docker run -env EASYRSA_CERT_EXPIRE=3650 --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-client-conf ...
```

## vpn-cli
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli --help
```

## windows 客户端IP区间

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