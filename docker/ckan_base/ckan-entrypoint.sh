#!/bin/sh
set -e

# URL for the primary database, in the format expected by sqlalchemy (required
# unless linked to a container called 'db')
: ${CKAN_SQLALCHEMY_URL:=}
# URL for solr (required unless linked to a container called 'solr')
: ${CKAN_SOLR_URL:=}
# URL for redis (required unless linked to a container called 'redis')
: ${CKAN_REDIS_URL:=}

CONFIG="${CKAN_CONFIG}/ckan.ini"
first_time=false

abort () {
  echo "$@" >&2
  exit 1
}

set_environment () {
  export CKAN_SQLALCHEMY_URL=${CKAN_SQLALCHEMY_URL}
  export CKAN_SOLR_URL=${CKAN_SOLR_URL}
  export CKAN_REDIS_URL=${CKAN_REDIS_URL}
  export CKAN_STORAGE_PATH=${CKAN_STORAGE_PATH}
  export CKAN_SITE_URL=${CKAN_SITE_URL}
}

write_config () {
  # Note that this only gets called if there is no config, see below!
  ckan-paster make-config --no-interactive ckan "$CONFIG"

  # The variables above will be used by CKAN, but
  # in case want to use the config from ckan.ini use this
  ckan-paster --plugin=ckan config-tool "$CONFIG" -e \
     "sqlalchemy.url = ${CKAN_SQLALCHEMY_URL}" \
     "solr_url = ${CKAN_SOLR_URL}" \
     "ckan.storage_path = ${CKAN_STORAGE_PATH}" \
     "ckan.site_url = ${CKAN_SITE_URL}" \
     "ckan.datapusher.url = ${CKAN_PUSHER_URL}" \
     "ckan.datastore.write_url = ${CKAN_DATASTORE_WRITE}" \
     "ckan.datastore.read_url = ${CKAN_DATASTORE_READ}" \
     "ckan.plugins = stats text_view image_view recline_view resource_proxy datastore datapusher webpage_view videoviewer" \
     "ckan.datapusher.formats = csv xls xlsx tsv application/csv application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 

}

# If we don't already have a config file, bootstrap
if [ ! -e "$CONFIG" ]; then
  write_config
  first_time=true
fi

# Set environment variables
if [ -z "$CKAN_SQLALCHEMY_URL" ]; then
    abort "ERROR: no CKAN_SQLALCHEMY_URL specified and linked container called 'db' was not found"
else
    # wait for postgres db to be available, immediately after creation
    # its entrypoint creates the cluster and dbs and this can take a moment
    for tries in $(seq 30); do
      psql -c 'SELECT 1;' 2> /dev/null && break
      sleep 0.3
    done
fi

if [ -z "$CKAN_SOLR_URL" ]; then
    abort "ERROR: no CKAN_SOLR_URL specified and linked container called 'solr' was not found"
fi
    

set_environment

# Initializes the Database
ckan-paster --plugin=ckan db init -c "${CKAN_CONFIG}/ckan.ini"

if [ "$first_time" = true ] ; then
  ckan-paster --plugin=ckan search-index rebuild -c $CKAN_CONFIG/ckan.ini
fi

exec "$@"