FROM odoo:latest

# Install additional dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    some-dependency \
    && rm -rf /var/lib/apt/lists/*

# Copy custom addons if you have any
COPY ./custom-addons /mnt/extra-addons

# Copy configuration file
COPY ./odoo.conf /etc/odoo/