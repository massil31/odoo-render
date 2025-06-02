#!/bin/bash
set -e

# Generate final config file with environment variables
python3 -c "
import os
with open('/etc/odoo/odoo.conf.template') as f:
    print(f.read() % os.environ)
" > /etc/odoo/odoo.conf

# Verify PostgreSQL connection
echo "Testing PostgreSQL connection at ${DB_HOST}:${DB_PORT}..."
while ! pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

exec odoo --config /etc/odoo/odoo.conf "$@"