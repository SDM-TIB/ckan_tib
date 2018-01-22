import factory
from ckanext.ggauth.model import Authorization, StatusClass
import ckan.tests.helpers as helpers


class Authorization(factory.Factory):
    '''A factory class for creating CKAN authorizations.'''

    FACTORY_FOR = Authorization

    download = StatusClass.APPROVED.value
    preview = StatusClass.APPROVED.value
    schema = StatusClass.APPROVED.value

    @classmethod
    def _build(cls, target_class, *args, **kwargs):
        raise NotImplementedError(".build() isn't supported in CKAN")

    @classmethod
    def _create(cls, target_class, *args, **kwargs):
        if args:
            assert False, "Positional args aren't supported, use keyword args."
        auth = helpers.call_action('permission_create', **kwargs)
        return auth
