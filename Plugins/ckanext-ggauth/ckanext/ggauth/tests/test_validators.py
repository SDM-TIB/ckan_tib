import ckanext.ggauth.validators as validators
from ckanext.ggauth.model import StatusClass


def test_enum_value_in_enum():
    assert validators.auth_enum_value(
        StatusClass.APPROVED.value) == StatusClass.APPROVED.value


def test_enum_value_not_in_enum():
    for i in ["random", None]:
        yield enum_default, i


def enum_default(value):
    assert validators.auth_enum_value(value) == StatusClass.NONE.value
