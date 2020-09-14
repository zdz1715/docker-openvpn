# docker-openvpn

## Usage
1.创建卷
```shell script
docker volume create --name openvpn
```
2.初始化
```shell script
docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli init
```
3.运行，推荐host模式，提高网络性能
```shell script
docker run --net=host -d --privileged --restart always -v openvpn:/etc/openvpn zdzserver/docker-openvpn
```
4.生成客户端
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli build-client-conf -n user1 -r $REMOTE_IP
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
* 设置CA有效期
```shell script
 docker run --rm -it -v openvpn:/etc/openvpn zdzserver/docker-openvpn vpn-cli list
```