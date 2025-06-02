#!/bin/bash
set -e

# Generate final config
python3 -c "import os; open('/etc/odoo/odoo.conf', 'w').write(open('/etc/odoo/odoo.conf.template').read() % os.environ)"

# Verify PostgreSQL connection
echo "Testing PostgreSQL connection at ${DB_HOST}:${DB_PORT}..."
while ! pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Initialize DB if not exists
if ! PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    echo "Initializing new database..."
    odoo -d "$DB_NAME" --db_host="$DB_HOST" --db_user="$DB_USER" --db_password="$DB_PASSWORD" -i base --stop-after-init
fi

# Start Odoo normally
exec odoo --config /etc/odoo/odoo.conf "$@"
