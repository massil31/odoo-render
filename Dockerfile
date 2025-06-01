FROM odoo:latest

# Install dependencies (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy custom addons (if any)
COPY ./addons /mnt/extra-addons

# Copy configuration
COPY ./odoo.conf /etc/odoo/