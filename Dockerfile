FROM odoo:latest

USER root

# Install dependencies (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
python3-pip \
&& rm -rf /var/lib/apt/lists/*

USER odoo

# Copy custom addons (if any)
COPY ./addons /mnt/extra-addons

# Copy configuration
COPY ./odoo.conf /etc/odoo/