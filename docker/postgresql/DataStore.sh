#!/bin/bash
set -e

echo "Creating additional datastore_default"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER datastore_default PASSWORD 'datastore';
	CREATE DATABASE datastore_default;
	GRANT ALL PRIVILEGES ON DATABASE datastore_default TO $POSTGRES_USER;
EOSQL