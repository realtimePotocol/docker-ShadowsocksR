# About ShadowsocksR of Docker
# 
# Version:1.0

FROM ubuntu:14.04
MAINTAINER cms88168

ENV REFRESHED_AT 2015-11-30

RUN apt-get -qq update && \
    apt-get install -q -y wget build-essential python-pip python-m2crypto m2crypto git&& \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#add chacha20
RUN wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz && \
    tar zxf LATEST.tar.gz && \
    cd libsodium* && \
    ./configure && make -j2 && make install && \
    ldconfig

RUN cd ~ && \
    git clone -b manyuser https://github.com/breakwa11/shadowsocks.git

ENV SS_SERVER_PORT 8388
ENV SS_PASSWORD password
ENV SS_METHOD aes-256-cfb
ENV SS_TIMEOUT 300
ENV SS_PROTOCOL origin
ENV SS_OBFS http_simple
ENV SS_OBFSP ""

RUN echo "{
    "server":"0.0.0.0",
    "server_ipv6": "::",
    "server_port":$SS_SERVER_PORT,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"$SS_PASSWORD",
    "timeout":$SS_TIMEOUT,
    "method":"$SS_METHOD",
    "protocol":"$SS_PROTOCOL",
    "obfs":"$SS_OBFS",
    "obfs_param":$SS_OBFSP
    "fast_open": false,
    "workers": 1
}" > /etc/shadowsocksr.json

ADD start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

EXPOSE $SS_SERVER_PORT

CMD ["sh", "-c", "start.sh"]
#ENTRYPOINT ["/usr/local/bin/python"]
