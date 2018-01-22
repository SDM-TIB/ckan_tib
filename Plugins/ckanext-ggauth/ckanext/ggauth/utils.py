import ckan.logic as logic
from ckan.plugins.toolkit import Invalid
import ckan.lib.helpers as h
from ckanext.ggauth.model import StatusClass
from ckan.lib.mailer import mail_recipient
from ckan.common import config
from logging import getLogger
import ckan.authz as authz
from ckan.logic.validators import (group_id_or_name_exists,
                                   role_exists, user_id_or_name_exists)
from ckan.lib.navl.validators import (not_missing)

NotFound = logic.NotFound

# Current implemented permissions
PERMISSIONS_LIST = ["download", "preview", "schema"]

# We decided we dont need an editor role
del authz.ROLE_PERMISSIONS["editor"]

log = getLogger(__name__)


def one_admin(key, flattened_data, errors, context):
    '''
        Limits the quantity of admins inside an organization to 1
    '''
    if flattened_data[('role',)] == 'admin':
        try:
                get_org_admin(context, flattened_data[('id',)])
                raise Invalid("There can only be one admin per organization.")
        except (IndexError, NotFound):
            return flattened_data[key]
    return flattened_data[key]


def member_schema_replace():
    schema = {
        'id': [not_missing, group_id_or_name_exists, unicode],
        'username': [not_missing, user_id_or_name_exists, unicode],
        'role': [not_missing, role_exists, one_admin, unicode],
    }
    return schema


# We dont want to allow more than one admin per organization
logic.schema.member_schema = member_schema_replace


def org_name_to_id(context, org_name):
    '''
        Translates org_name to org_id
    '''
    model = context["model"]
    org = model.Group.get(org_name)
    if not org:
        raise logic.NotFound
    return org.id


def get_org_admin(context, org_name):
    '''
        Gets the admin user given an organization
    '''
    member_dict = {
        "id": org_name,
        "object_type": "user",
        "capacity": "admin",
    }
    try:
        admin_list = logic.get_action("member_list")(
                     context, member_dict)
        if not admin_list:
            raise logic.NotFound
        user_id, _, _ = admin_list[0]
        user_name = context["model"].User.get(user_id)
        fake_context = dict(context)
        fake_context["user"] = user_name.name

        user = logic.get_action("user_show")(fake_context, {"id": user_id})
        return user
    except IndexError, NotFound:
        raise logic.NotFound


def send_acceptance_email(context, data_dict):
    '''
        Sends an email to the target organization which rights have been
        modified.
    '''
    new_permissions = []
    blocked_permissions = []
    for key in PERMISSIONS_LIST:
        if data_dict[key] == StatusClass.APPROVED.value:
            new_permissions.append(key)
        elif data_dict[key] == StatusClass.DENIED.value:
            blocked_permissions.append(key)
    user = get_org_admin(context, data_dict["org_name"])

    subject = "Your rights changed: {res}".format(
               user=context["user"], res=data_dict["resource_id"]
               )
    body = ""
    if blocked_permissions:
        body += "These rights were blocked: \n"
        body += " * "+"\n * ".join(blocked_permissions) + "\n\n"
    if new_permissions:
        body += "These rights were granted: \n"
        body += " * "+"\n * ".join(new_permissions) + "\n\n"

    return mail_recipient(user["name"], user["email"],
                          subject, body)


def send_request_email(context, data_dict):
    '''
    data_dict["id"] = pkg_id
    data_dict["resource"] = resource
    data_dict["resource_id"] = resource_id
    data_dict["org_name"] = org_name
    '''
    model = context["model"]
    resource = model.Resource.get(data_dict["resource_id"])

    user = get_org_admin(context, resource.package.owner_org)

    url = h.url_for("resource_new_permission",
                    id=data_dict["id"], resource_id=data_dict["resource_id"],
                    org=data_dict["org_name"]
                    )

    url = "{prefix}{url}".format(
        prefix=config.get('ckan.site_url', None),
        url=url
        )

    subject = "{user} has requested access to your resource: {res}".format(
               user=context["user"], res=data_dict["resource_id"]
               )
    body = ("You can give him access, "
            "through this link: \n\n {url} ").format(
            url=url
            )

    return mail_recipient(user["name"], user["email"],
                          subject, body)
