FROM alpine:3.12
LABEL maintainer="jacob@tlacuache.us"
WORKDIR /usr/src

RUN apk update --no-cache && apk add -U --no-cache \
        alpine-sdk build-base git openssl-dev cyrus-sasl-dev util-linux-dev db-dev groff unixodbc-dev libtool mosquitto-dev autoconf automake libsodium-dev openldap-dev

RUN git clone https://git.alpinelinux.org/aports --single-branch --branch 3.12-stable /usr/src/aports &&\
        git clone https://github.com/openldap/openldap openldap
RUN     cd aports/main/openldap &&\
        abuild -F fetch &&\
        abuild -F unpack &&\
        abuild -F prepare &&\
        abuild -F build
RUN     cp -R /usr/src/openldap/contrib/slapd-modules/passwd/argon2 /usr/src/aports/main/openldap/src/openldap-*/contrib/slapd-modules/passwd/argon2 &&\
        cd /usr/src/aports/main/openldap/src/openldap-*/contrib/slapd-modules/passwd/argon2 &&\
        make &&\
        make install &&\
        rm -r /usr/src/*
