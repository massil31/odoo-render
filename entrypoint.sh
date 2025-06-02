#!/bin/bash
set -e

# Generate final config
python3 -c "import os; open('/etc/odoo/odoo.conf', 'w').write(open('/etc/odoo/odoo.conf.template').read() % os.environ)"

# Check if DB exists and has tables
DB_CHECK=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT 1 FROM pg_tables WHERE tablename='ir_module_module'")

# Initialize new DB if tables are missing
if [ -z "$DB_CHECK" ]; then
    echo "Initializing new database..."
    odoo-bin -d "$DB_NAME" \
        --db_host="$DB_HOST" \
        --db_user="$DB_USER" \
        --db_password="$DB_PASSWORD" \
        -i base,web \
        --stop-after-init \
        --without-demo=all
fi

# Start Odoo normally
exec odoo --config /etc/odoo/odoo.conf "$@"
