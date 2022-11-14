# syntax=docker/dockerfile:1.4

ARG FRAPPE_VERSION=14
# # Prepare builder image
# FROM frappe/bench:latest as assets

# ARG FRAPPE_VERSION=14
# ARG ERPNEXT_VERSION=14
# # frappe v13 only works with NODE_VERSION=14
# ARG NODE_VERSION=16

# ## bash -l to use bash login mode to load the bashrc and be able to define the nvm paths
# SHELL ["/bin/bash", "-l", "-c"]
# RUN nvm alias default $NODE_VERSION && \
#     nvm use default

# #below to check if the node version changed
# # RUN node -v && sleep 11 && nvm ls default && sleep 10

# # Setup frappe-bench using FRAPPE_VERSION
# RUN bench init --version=version-${FRAPPE_VERSION} --skip-redis-config-generation --verbose --skip-assets /home/frappe/frappe-bench
# WORKDIR /home/frappe/frappe-bench

# # Comment following if ERPNext is not required
# RUN bench get-app --branch=version-${ERPNEXT_VERSION} --skip-assets --resolve-deps erpnext
# RUN bench get-app --skip-assets --resolve-deps https://github.com/michaeleino/erpnext-persistent_defaults.git

# # Copy custom app(s)
# #COPY --from=base --chown=frappe:frappe /root/apps/ apps/


# # Setup dependencies
# RUN bench setup requirements
# # RUN mv apps/{erpnext-customstyle,customstyle} && mv apps/{erpnext-persistent_defaults,persistent_defaults} && bench setup requirements

# # Build static assets, copy files instead of symlink
# RUN bench build --verbose --hard-link


# Use frappe-nginx image with nginx template and env vars
FROM frappe/frappe-nginx:${FRAPPE_VERSION}

# Remove existing assets
USER root
RUN rm -fr /usr/share/nginx/html/assets

# Copy built assets
COPY --from=base /home/frappe/frappe-bench/sites/assets /usr/share/nginx/html/assets

# Use non-root user
USER 1000
