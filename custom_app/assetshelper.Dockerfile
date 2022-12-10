# syntax=docker/dockerfile:1.4

# Prepare builder image
FROM frappe/bench:latest as assets

ARG FRAPPE_VERSION=14
ARG ERPNEXT_VERSION=14
# frappe v13 only works with NODE_VERSION=14
ARG NODE_VERSION=16
ARG MULTI_APPS_REPOS

## bash -l to use bash login mode to load the bashrc and be able to define the nvm paths
SHELL ["/bin/bash", "-l", "-c"]
RUN nvm alias default $NODE_VERSION && \
    nvm use default

#below to check if the node version changed
# RUN node -v && sleep 11 && nvm ls default && sleep 10

# Setup frappe-bench using FRAPPE_VERSION
RUN bench init --version=v${FRAPPE_VERSION} --skip-redis-config-generation --verbose --skip-assets /home/frappe/frappe-bench
WORKDIR /home/frappe/frappe-bench

# Comment following if ERPNext is not required
RUN bench get-app --branch=v${ERPNEXT_VERSION} --skip-assets --resolve-deps erpnext
#loop over apps
RUN for app in $MULTI_APPS_REPOS; \
    do \
    bench get-app --skip-assets --resolve-deps $app; \
    done && \
    chown -R 1000:1000 ./ 
    #&& \
    # ls -alh && \
    # ls -alh ../* && \
    # ls -alh apps/

# Copy custom app(s)
#COPY --from=base --chown=frappe:frappe /root/apps/ apps/


# Setup dependencies
RUN bench setup requirements
# RUN mv apps/{erpnext-customstyle,customstyle} && mv apps/{erpnext-persistent_defaults,persistent_defaults} && bench setup requirements

# Build static assets, copy files instead of symlink
RUN bench build --verbose --hard-link


##old trial to be removed
# FROM alpine:3.16 as onlycloner
# ARG CLONED_APPS_REPOS
# RUN apk add git && \
#     mkdir -p /root/apps

# WORKDIR /root/apps

# RUN for app in $CLONED_APPS_REPOS; \
#     do \
#     git clone $app; \
#     done && \
#     chown -R 1000:1000 ./ && \
#     ls -alh
