# encoding: utf-8

import ckan.controllers.package as package
import ckan.lib.base as base
import ckan.lib.helpers as h
import ckan.lib.navl.dictization_functions as dict_fns
import ckan.logic as logic
import ckan.model as model
import ckan.plugins as plugins
from ckanext.ggauth.model import StatusClass
from ckan.controllers.api import ApiController
from ckanext.ggauth.utils import PERMISSIONS_LIST

from ckan.common import _, c


from logging import getLogger

log = getLogger(__name__)
check_access = logic.check_access

render = base.render
abort = base.abort
request = base.request

NotAuthorized = logic.NotAuthorized
NotFound = logic.NotFound


class AuthApiController(ApiController):
    '''
        Auth API controller, enables authorization system on API calls.
    '''
    # Each auth could need different information, find a way to pass
    # also the data_dict
    auth_mapping = {
        "datastore_search": "resource_schema"
    }

    def auth_action(self, logic_function=None, *args, **kwargs):
        if logic_function in self.auth_mapping:
            function = logic.get_action(logic_function)
            try:
                side_effect_free = getattr(function, 'side_effect_free', False)
                request_data = self._get_request_data(
                                            try_url_params=side_effect_free)
                context = {'model': model, 'session': model.Session,
                           'user': c.user,
                           'auth_user_obj': c.userobj}
                check_access(self.auth_mapping[logic_function], context,
                             {'resource_id': request_data["resource_id"]})

            except (ValueError, KeyError), inst:
                log.info('Bad Action API request data: %s', inst)
            except NotAuthorized, e:
                return_dict = {}
                return_dict['error'] = {'__type': 'Authorization Error',
                                        'message': _('Access denied')}
                return_dict['success'] = False

                if unicode(e):
                    return_dict['error']['message'] += u': %s' % e

                return self._finish(403, return_dict, content_type='json')
            return self.action(logic_function, 3)
        else:
            return self.disabled()

    def disabled(self, *args, **kwargs):
        return 'This API call has been disabled'


class PermissionController(package.PackageController):

    def _redirect_to_this_controller(self, *args, **kw):
        kw['controller'] = request.environ['pylons.routes_dict']['controller']
        return h.redirect_to(*args, **kw)

    def resource_read(self, id, resource_id):
        '''
            Decorator of normal resource_read, adding extra
            permission to be able to read a resource.
        '''
        context = {'model': model, 'session': model.Session,
                   'user': c.user,
                   'auth_user_obj': c.userobj,
                   'for_view': True}
        try:
            check_access("resource_on_request", context,
                         {'id': id,
                          'resource_id': resource_id})
        except NotAuthorized:
            plugins.toolkit.redirect_to(
                controller=('ckanext.ggauth.controller.'
                            'permissions:PermissionController'),
                action='ask_permission',
                id=id,
                resource_id=resource_id)

        return super(PermissionController, self).resource_read(id, resource_id)

    '''
        Lists all user permissions for a given resource
    '''
    def admin_permission(self, id, resource_id):

        context = {'model': model,
                   'session': model.Session,
                   'user': c.user,
                   'auth_user_obj': c.userobj}

        try:
            check_access("resource_update", context, {'id': resource_id})
            c.pkg_dict = plugins.toolkit.get_action('package_show')(
                         context, {'id': id})
            c.resource = plugins.toolkit.get_action('resource_show')(
                         context, {'id': resource_id})
            c.members = plugins.toolkit.get_action('permission_list')(
                        context, {'id': resource_id})
        except NotAuthorized:
            abort(403, _('Not authorized to see this page'))

        return plugins.toolkit.render('package/resource_permissions.html')

    '''
        Allows the creation and modification of permissions for a
        given resource and user
    '''

    def new_permission(self, id, resource_id, data=None):
        '''
            Review this
        '''
        context = {'model': model,
                   'session': model.Session,
                   'user': c.user,
                   'auth_user_obj': c.userobj}

        try:
            check_access("resource_update", context,
                         {'user': c.user, 'id': resource_id})
            c.pkg_dict = plugins.toolkit.get_action('package_show')(
                         context, {'id': id})
            c.resource = plugins.toolkit.get_action('resource_show')(
                         context, {'id': resource_id})
        except NotAuthorized:
            abort(403, _('Not authorized to see this page'))

        # Default initialization
        for attr in PERMISSIONS_LIST:
            setattr(c, attr, 'None')

        vars = {"s_options": StatusClass.selectbox()}

        if request.method == 'POST':
            # data_dict = clean_dict(dict_fns.unflatten(
            #     tuplize_dict(parse_params(request.params))))
            data = data or \
                logic.clean_dict(
                    dict_fns.unflatten(
                        logic.tuplize_dict(
                            logic.parse_params(
                                                request.POST))))
            data_dict = {
                "resource_id": resource_id,
                "org_name": data["organization"],
            }

            # Add data coming from POST
            for attr in PERMISSIONS_LIST:
                data_dict[attr] = data["auth.{attr}".format(attr=attr)]

            try:
                logic.get_action("permission_create")(context, data_dict)
            except NotFound:
                h.flash_error("Organization not found")
                # Include error that or was not found
                return plugins.toolkit.render(
                    'permission/permission_new.html', extra_vars=vars)
            self._redirect_to_this_controller(
                action='admin_permission', id=id, resource_id=resource_id)
        else:
            org = request.params.get('org')
            if org:
                c.org_name = org
                results = logic.get_action("permission_show")(
                    context, {'org_name': org,
                              'id': id,
                              'resource_id': resource_id})

                for attr in PERMISSIONS_LIST:
                    setattr(c, attr, results[attr])

        return plugins.toolkit.render('permission/permission_new.html',
                                      extra_vars=vars)

    '''
        Allows the user to request permissions for resources
    '''
    def ask_permission(self, id, resource_id, data=None):
        # Check if logged_in, otherwise we cannot send the request
        if not c.user:
            controller = request.environ['pylons.routes_dict']['controller']
            came_from = h.url_for(controller=controller,
                                  action='ask_permission',
                                  id=id, resource_id=resource_id,
                                  __ckan_no_root=True)
            h.redirect_to(controller='user', action='login',
                          id=None,  came_from=came_from)

        try:
            org = h.organizations_available("admin")[0]
        except IndexError:
            abort(403, _('You need to be an organization'
                         ' administrator to request permission'))

        # Parse post
        if request.method == 'POST' and not data:
            context = {'model': model, 'session': model.Session,
                       'api_version': 3, 'for_edit': True,
                       'user': c.user, 'auth_user_obj': c.userobj}
            data = data or \
                logic.clean_dict(
                    dict_fns.unflatten(
                        logic.tuplize_dict(
                            logic.parse_params(
                                                request.POST))))
            del data["save"]

            data["resource_id"] = resource_id
            data["id"] = id
            data["user"] = c.user
            data["org_name"] = org["name"]

            # Set to PENDING if permission requested on website
            for attr in PERMISSIONS_LIST:
                key = "auth.{attr}".format(attr=attr)
                data[attr] = StatusClass.PENDING.value if key in data else None

            # Update database
            try:
                logic.get_action("permission_request")(context, data)
            except NotAuthorized:
                abort(403,
                      _('Unauthorized to ask permission, \
                        contact your administrator'))
            plugins.toolkit.redirect_to(h.url_for(
                            controller='package',
                            action='resource_read',
                            id=id, resource_id=resource_id))

        context = {'model': model,
                   'session': model.Session,
                   'user': c.user,
                   'auth_user_obj': c.userobj}

        try:
            c.resource = plugins.toolkit.get_action('resource_show')(
                    context, {'id': resource_id})
            c.pkg_dict = plugins.toolkit.get_action('package_show')(
                    context, {'id': id})

            permission = plugins.toolkit.get_action('permission_show')(
                     context, {'resource_id': resource_id,
                               'org_name': org["name"]})
        except (NotFound, NotAuthorized):
            abort(404, _('Resource not found'))

        data = {"user": c.user, 'id': id, "resource_id": resource_id}

        data["permission"] = permission

        attrs = {}
        for attr in PERMISSIONS_LIST:
            if permission[attr] == StatusClass.NONE.value:
                attrs[attr] = {}
            else:
                attrs[attr] = {"disabled": ""}

        vars = {'data': data, 'errors': {}, 'res': c.resource, 'attrs': attrs}
        # Change for the actual template that we are grabonna use
        return plugins.toolkit.render('package/resource_ask.html',
                                      extra_vars=vars)
