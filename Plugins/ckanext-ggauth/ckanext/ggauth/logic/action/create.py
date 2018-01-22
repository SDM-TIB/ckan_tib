import ckan.logic as logic
import ckan.model as model
import ckan.plugins as plugins
import logging
from ckanext.ggauth.model import Authorization, StatusClass
from ckanext.ggauth.utils import (org_name_to_id, send_request_email,
                                  send_acceptance_email, PERMISSIONS_LIST)

_get_or_bust = logic.get_or_bust

log = logging.getLogger(__name__)


def permission_create(context, data_dict):
    '''
        data_dict ["download"] StatusClass.ENUM.value
        data_dict ["schema"] StatusClass.ENUM.value
        data_dict ["preview"] StatusClass.ENUM.value
        data_dict ["org_name"] String
        data_dict ["resource_id"] String
    '''
    logic.check_access('permission_create', context, data_dict)

    permission_object = plugins.toolkit.get_action(
                            'permission_get')(context, data_dict)

    send_acceptance_email(context, data_dict)

    if permission_object is None:
        return _new_permission(context, data_dict)
    else:
        return _permission_update(context, data_dict, permission_object)


def permission_request(context, data_dict):

    permission = plugins.toolkit.get_action('permission_get')(
                 context, data_dict)

    logic.check_access('permission_request', context, data_dict)

    send_request_email(context, data_dict)

    if permission is None:
        _new_permission(context, data_dict)
    else:
        # We can only override NONE value
        for attr in PERMISSIONS_LIST:
            new = data_dict[attr]
            old = getattr(permission, attr)
            if not new or old != StatusClass.NONE.value:
                data_dict[attr] = old

        permission = _permission_update(context, data_dict, permission)


def _permission_update(context, data_dict, permission_object):
    '''
        data_dict ["download"] StatusClass.ENUM.value
        data_dict ["schema"] StatusClass.ENUM.value
        data_dict ["preview"] StatusClass.ENUM.value
    '''
    logic.check_access('permission_create', context, data_dict)

    for attr in PERMISSIONS_LIST:
        setattr(permission_object, attr, data_dict[attr])

    model.Session.commit()
    return permission_object


def _new_permission(context, data_dict):
    '''
        data_dict ["download"] StatusClass.ENUM.value
        data_dict ["schema"] StatusClass.ENUM.value
        data_dict ["preview"] StatusClass.ENUM.value
        data_dict ["org_name"] String
        data_dict ["resource_id"] String
    '''
    org_id = org_name_to_id(context, data_dict["org_name"])

    permission_values = {
        attr: data_dict[attr] for attr in PERMISSIONS_LIST
    }

    permission = Authorization(resource_id=data_dict["resource_id"],
                               group_id=org_id,
                               **permission_values)

    model.Session.add(permission)
    model.Session.commit()
    return permission
