# syntax=docker/dockerfile:1.4

FROM alpine:3.16 as onlycloner
ARG CLONED_APPS_REPOS
RUN apk add git && \
    mkdir -p /root/apps

WORKDIR /root/apps

RUN for app in $CLONED_APPS_REPOS; \
    do \
    git clone $app; \
    done && \
    chown -R 1000:1000 ./ && \
    ls -alh
