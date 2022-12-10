# syntax=docker/dockerfile:1.4
ARG ERPNEXT_VERSION

FROM frappe/erpnext-worker:v${ERPNEXT_VERSION}

USER root

ARG APPS_NAME

# COPY --from=base /root/apps/ ../apps/
COPY --from=base /home/frappe/frappe-bench/apps /tmp/apps/

#get all apps by folder excluding frappe & erpnext
RUN APPS_NAME=`ls /tmp/apps/ -Ierpnext -Ifrappe` && \
    echo "found apps: ${APPS_NAME}" && \
    for app in ${APPS_NAME}; \
    do \
    # --mount=type=cache,target=/root/.cache/pip \
    mv /tmp/apps/$app /home/frappe/frappe-bench/apps/ && \
    echo "Installing app ${app}" && \
    install-app ${app} ; \
    done
    # ls -alh ../apps

USER frappe
