FROM miek/coredns
MAINTAINER Arne Jørgensen <arne@arnested.dk>

ADD docker-alpine/3.4/rootfs/ /

RUN apk update && apk upgrade && \
    apk add curl && \
    apk add ca-certificates supervisor rsyslog supervisor && \
    chmod +x /my_* && \
    mkdir /etc/my_runonce /etc/my_runalways /etc/container_environment /etc/workaround-docker-2267 /var/log/supervisor && \
    touch /var/log/startup.log && chmod 666 /var/log/startup.log && \
          rm -rf /var/cache/apk/*

ENV DOCKER_GEN_VERSION 0.7.1

RUN curl -sL -o docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

ADD etc /etc

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT ["/my_init"]
