FROM ckan/postgresql
ADD init.sh /docker-entrypoint-initdb.d/init.sh

ADD ckan.sql /etc/ckan.sql
ADD datastore.sql /etc/datastore.sql
