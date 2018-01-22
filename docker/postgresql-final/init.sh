#!/bin/bash
set -e

echo "Creating additional datastore_default"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER datastore_default PASSWORD 'datastore';
	CREATE DATABASE datastore_default;
	GRANT ALL PRIVILEGES ON DATABASE datastore_default TO $POSTGRES_USER;
EOSQL

echo "Executing scripts"

psql -U "$POSTGRES_USER" -d ckan -f /etc/ckan.sql

psql -U "$POSTGRES_USER" -d datastore_default -f /etc/datastore.sql
