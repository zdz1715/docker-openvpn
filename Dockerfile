FROM ubuntu:20.04

## 换源 复制配置
COPY etc /etc/

RUN apt-get update; \
    apt-get install -y tzdata; \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    apt install -y openvpn easy-rsa; \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin;



ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars
ENV OVPN_ENV $OPENVPN/.env

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/etc/openvpn"]


ADD ./bin /usr/local/bin

RUN chmod +x /entrypoint.sh; \
    chmod a+x /usr/local/bin/*;

ENTRYPOINT ["/entrypoint.sh"]
