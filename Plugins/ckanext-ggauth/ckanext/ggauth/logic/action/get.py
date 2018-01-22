import ckan.logic as logic
from ckanext.ggauth.model import Authorization, StatusClass
from ckanext.ggauth.utils import org_name_to_id

from logging import getLogger


log = getLogger(__name__)


_get_or_bust = logic.get_or_bust


def permission_list(context, data_dict):
    model = context['model']
    id = _get_or_bust(data_dict, 'id')

    logic.check_access('permission_list', context, data_dict)

    context['resource'] = model.Resource.get(id)

    permissions = model.Session.query(Authorization).filter(
        Authorization.resource_id == id).all()

    permissions = [(p.group_id, p.preview, p.download, p.schema)
                   for p in permissions]

    return permissions


def permission_get(context, data_dict):
    model = context['model']

    resource_id = data_dict['resource_id']
    org_id = org_name_to_id(context, data_dict["org_name"])
    data_dict["org_id"] = org_id
    logic.check_access('permission_get', context, data_dict)

    query = model.Session.query(Authorization).\
        filter(Authorization.resource_id == resource_id,
               Authorization.group_id == org_id)

    return query.first()


def permission_show(context, data_dict=None):
    '''
        Given an org and a resource, return the org permissions
        data_dict["org_name"]
        data_dict["resource_id"]
    '''
    resource_id = data_dict['resource_id']

    permissions = permission_get(context, data_dict)

    permissions = permissions or {}
    result = {}

    result["resource_id"] = resource_id
    result["download"] = getattr(permissions, 'download',
                                 StatusClass.NONE.value)
    result["schema"] = getattr(permissions, 'schema', StatusClass.NONE.value)
    result["preview"] = getattr(permissions, 'preview', StatusClass.NONE.value)

    return result
