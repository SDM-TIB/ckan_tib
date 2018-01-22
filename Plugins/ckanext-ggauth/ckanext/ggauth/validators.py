from ckanext.ggauth.model import StatusClass


def auth_enum_value(value):
    if value not in StatusClass.list():
        value = StatusClass.NONE.value
    return value
