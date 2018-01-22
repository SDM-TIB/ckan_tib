FROM ckan/postgresql
ADD init.sh /docker-entrypoint-initdb.d/init.sh

ADD ckan09012017.sql /etc/ckan.sql
ADD datastore09012017.sql /etc/datastore.sql
