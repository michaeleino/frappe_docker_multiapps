# syntax=docker/dockerfile:1.4
ARG ERPNEXT_VERSION

FROM frappe/erpnext-worker:v${ERPNEXT_VERSION}

USER root

ARG APPS_NAME

COPY --from=base /root/apps/ ../apps/

RUN for app in ${APPS_NAME}; \
    do \
    # --mount=type=cache,target=/root/.cache/pip \
    install-app ${app} ; \
    done && \
    echo ${ERPNEXT_VERSION}

USER frappe
