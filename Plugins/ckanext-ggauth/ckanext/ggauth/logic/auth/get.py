import ckan.authz as authz
import ckan.lib.dictization.model_dictize as model_dictize
import ckan.logic as logic
import ckan.model as model
import ckan.plugins as plugins

from logging import getLogger
from ckan.lib import helpers as h
from ckanext.ggauth.model import StatusClass
from ckan.common import c


log = getLogger(__name__)


'''
    Returns the list of users and their respective permissions for a given
    resource
'''


def permission_list(context, data_dict):
    return authz.is_authorized('resource_update', context, data_dict)


def check_group_permission(context, data_dict, permission):
    '''
        /usr/lib/ckan/default/src/ckan/ckan/authz.py:
        184  ROLE_PERMISSIONS = OrderedDict([
        185      ('admin', ['admin']),
        186:     ('editor', ['read', 'delete_dataset',
        'create_dataset', 'update_dataset', 'manage_group']),
        187      ('member', ['read', 'manage_group']),
        188  ])
    '''
    package = logic.auth.get_package_object(context, data_dict)
    user = c.user

    # Check if user is in the organization and has permission to read
    if package.owner_org:
        return authz.has_user_permission_for_group_or_org(
             package.owner_org, user, permission
        )
    return False


def handle_resource_permission(context, data_dict, permission):
    '''
        Check resource permissions and permissions from orgs that the user
        belongs to.
        data_dict type: dictionary
        data_dict: must contain "resource_id"
        permission type: string
        permission: "download", "schema", "preview"
    '''
    resource_id = data_dict['resource_id']
    resource = model.Resource.get(resource_id)

    org_id = resource.package.owner_org

    resource = model_dictize.resource_dictize(resource, context)
    # Private is default by design
    value = resource.get(permission, "Private")
    if value == "Public":
        return {'success': True}
    else:
        if h.user_in_org_or_group(org_id):
            return {'success': True}

        if value == "Private":
            return {'success': False,
                    'msg': '%s for this resource is private.' % permission}
        else:
            # Check if any organization he belongs to has permission
            orgs = h.organizations_available(permission="read")
            for org in orgs:
                p = plugins.toolkit.get_action("permission_show")(
                    context, {"resource_id": resource_id,
                              "org_name": org["name"]})
                if p[permission] == StatusClass.APPROVED.value:
                    return {'success': True}

    return None


'''
    Check if the user has permission to download the resource
'''


@plugins.toolkit.auth_allow_anonymous_access
def resource_on_request(context, data_dict):

    check_resource = handle_resource_permission(context,
                                                data_dict, "preview")

    if check_resource:
        return check_resource

    return {'success': False, 'msg': 'You cannot see this resource'}


'''
    Check if the user has permission to download the resource
'''


@plugins.toolkit.auth_allow_anonymous_access
def resource_download(context, data_dict):

    check_resource = handle_resource_permission(context,
                                                data_dict, "download")

    if check_resource:
        return check_resource

    return {'success': False, 'msg': 'You cannot see this package'}


'''
    Check if the user has permission to preview the resource
'''


@plugins.toolkit.auth_allow_anonymous_access
def resource_schema(context, data_dict):

    check_resource = handle_resource_permission(context,
                                                data_dict, "schema")

    if check_resource:
        return check_resource

    return {'success': False, 'msg': 'You cannot see this package'}


def permission_show(context, data_dict=None):
    '''
        Just filter out whoever is not logged in
    '''
    return {'success': True}


def permission_get(context, data_dict=None):
    '''
        "id": self.package_id
        "resource_id"
    '''

    if h.user_in_org_or_group(data_dict["org_id"]):
        return {'success': True}

    group_allows = check_group_permission(context, data_dict, 'update_dataset')

    if group_allows:
            return {'success': True}
    return {'success': False, 'msg': 'You cannot see this authorization'}
