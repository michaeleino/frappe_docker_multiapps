# syntax=docker/dockerfile:1.3
ARG ERPNEXT_VERSION

FROM alpine:3.16 as onlycloner
ARG MULTIAPPS
RUN apk add git && \
    mkdir -p /root/apps

WORKDIR /root/apps

RUN for app in $MULTIAPPS; \
    do \
    git clone $app; \
    done && \
    chown -R 1000:1000 ./ && \
    ls -alh



FROM frappe/erpnext-worker:v13

USER root

ARG APP_NAME
ARG APPS

COPY --from=onlycloner /root/apps/ ../apps/

RUN for app in ${APPS}; \
    do \
    # --mount=type=cache,target=/root/.cache/pip \
    install-app ${app} ; \
    done && \
    echo ${ERPNEXT_VERSION}

USER frappe
