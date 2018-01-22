#!bin/bash
export PYTHONWARNINGS="ignore"
source $CKAN_HOME/bin/activate
nosetests --ckan -v -s --with-pylons=$CKAN_CONFIG/ckan_test.ini --nologcapture ckanext/ggauth/tests/test_utils.py