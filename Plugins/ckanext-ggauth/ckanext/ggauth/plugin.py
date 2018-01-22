# encoding: utf-8

from logging import getLogger

import ckan.plugins as plugins
import ckanext.ggauth.logic.action as action
import ckanext.ggauth.logic.auth as auth
import ckanext.ggauth.validators as validators
from routes.mapper import SubMapper

log = getLogger(__name__)


class GgauthPlugin(plugins.SingletonPlugin,
                   plugins.toolkit.DefaultDatasetForm):

    # Implements IActions to implement new actions
    plugins.implements(plugins.IActions)

    # Implements IAuthFunctions to implement new authorization functions
    plugins.implements(plugins.IAuthFunctions)

    # IValidator to enforce enum on auth fields
    plugins.implements(plugins.IValidators)

    # Extend resurce schema
    plugins.implements(plugins.IDatasetForm, inherit=True)

    # Implements IConfigurer to add new path for views
    plugins.implements(plugins.IConfigurer, inherit=True)

    # Implements IRoutes to override routes and create new ones
    plugins.implements(plugins.IRoutes, inherit=True)

    '''
        IDatasetForm implementation
    '''
    def _modify_package_schema(self, schema):
        schema['resources'].update({
            'download': [plugins.toolkit.get_validator('ignore_missing')],
            'preview': [plugins.toolkit.get_validator('ignore_missing')],
            'schema': [plugins.toolkit.get_validator('ignore_missing')]
            })
        return schema

    def show_package_schema(self):
        schema = super(GgauthPlugin, self).show_package_schema()
        schema = self._modify_package_schema(schema)
        return schema

    def create_package_schema(self):
        schema = super(GgauthPlugin, self).create_package_schema()
        schema = self._modify_package_schema(schema)
        return schema

    def update_package_schema(self):
        schema = super(GgauthPlugin, self).update_package_schema()
        schema = self._modify_package_schema(schema)
        return schema

    def is_fallback(self):
        return True

    def package_types(self):
        return []

    '''
        End IDatasetForm implementation
    '''

    def before_map(self, map):
        with SubMapper(map,
                       controller=('ckanext.ggauth.controller.'
                                   'permissions:PermissionController')) as m:

            '''
                Control who can see resources. (Resource on request, preview)
            '''
            m.connect('resource_read_modified',
                      '/dataset/{id}/resource/{resource_id}',
                      action='resource_read')

            '''
                As a user, check your current permissions, and let's
                you request them
            '''
            m.connect('resouce_request_permission',
                      '/dataset/{id}/resource/{resource_id}/ask',
                      action='ask_permission')

            '''
                As a resource admin, check all users and permissions
            '''
            m.connect('resource_permission_admin',
                      '/dataset/{id}/resource_edit/{resource_id}/permissions',
                      action='admin_permission')

            '''
                As a resource admin, check modify and create new
                permission for an user
            '''
            m.connect('resource_new_permission',
                      ('/dataset/{id}/resource_edit/'
                       '{resource_id}/permissions/new'),
                      action='new_permission')

            '''
                As a resource admin, grant change user permissions for a
                given resource
            '''
            m.connect('resource_permission_admin_user',
                      ('/dataset/{id}/resource_edit/{resource_id}/'
                       'permissions/{username}'),
                      action='admin_permission_user')

        # API routes
        with SubMapper(map,
                       controller=('ckanext.ggauth.controller.'
                                   'permissions:AuthApiController')) as m:

            m.connect('filter_api', '/api/3/action/{logic_function}',
                      action='auth_action')

            m.connect('redirect_api',
                      '/api{ver:/1|/2|/3|}/{act:rest|action}/*url',
                      action='disabled')

        return map

    def get_actions(self):

        return {
            'permission_ask_update': action.update.permission_ask,
            'permission_create': action.create.permission_create,
            'permission_get': action.get.permission_get,
            'permission_list': action.get.permission_list,
            'permission_request': action.create.permission_request,
            'permission_show': action.get.permission_show
        }

    def get_auth_functions(self):

        return {
            'permission_request': auth.create.permission_request,
            'permission_create': auth.create.permission_create,
            'permission_get': auth.get.permission_get,
            'permission_list': auth.get.permission_list,
            'resource_download': auth.get.resource_download,
            'resource_on_request': auth.get.resource_on_request,
            'resource_schema': auth.get.resource_schema
        }

    def get_validators(self):

        return {
            'auth_enum_value':  validators.auth_enum_value
        }

    def update_config(self, config):
        templates = 'templates'

        plugins.toolkit.add_template_directory(config, templates)
