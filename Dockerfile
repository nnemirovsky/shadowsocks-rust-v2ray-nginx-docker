FROM ghcr.io/shadowsocks/ssserver-rust:latest

USER root

RUN cd /etc/shadowsocks-rust && \
 TAG=$(wget -qO- https://api.github.com/repos/teddysun/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
 wget https://github.com/teddysun/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
 tar -xf *.gz && \
 rm *.gz && \
 mv v2ray* /usr/bin/v2ray-plugin && \
 chmod +x /usr/bin/v2ray-plugin

USER nobody

ENV PASSWORD="basic_password"

ENTRYPOINT exec ssserver --encrypt-method chacha20-ietf-poly1305 --server-addr 0.0.0.0:8388 --password $PASSWORD --fast-open --plugin /usr/bin/v2ray-plugin --plugin-opts "server;loglevel=trace"

