
FROM ckan_base
MAINTAINER Gabriel Gimenez @ Fraunhofer

# SetUp custom plugin
ADD ./Plugins/ckanext-videoviewer $CKAN_HOME/src/ckanext-videoviewer
RUN ckan-pip install -e $CKAN_HOME/src/ckanext-videoviewer

ADD ./Plugins/ckanext-TIBtheme $CKAN_HOME/src/ckanext-TIBtheme
RUN ckan-pip install -e $CKAN_HOME/src/ckanext-TIBtheme

ADD ./Plugins/ckanext-dcat $CKAN_HOME/src/ckanext-dcat
RUN ckan-pip install -e $CKAN_HOME/src/ckanext-dcat
RUN ckan-pip install -r $CKAN_HOME/src/ckanext-dcat/requirements.txt

COPY ./docker/ckan-entrypoint.sh /
RUN chmod +x /ckan-entrypoint.sh