import ckan.authz as authz
from ckan.common import _, c


def permission_create(context, data_dict):
    data_dict["id"] = data_dict["resource_id"]
    return authz.is_authorized('resource_update', context, data_dict)


def permission_request(context, data_dict):
    user = c.user
    permission = "admin"
    org = data_dict["org_name"]

    authorized = authz.has_user_permission_for_group_or_org(
             org, user, permission
        )

    if authorized:
        return {'success': True}
    else:
        return {'success': False, 'msg': _('User %s not authorized to request permission %s') % (user, org)}
