import ckanext.ggauth.tests.utils as utils
from ckan.logic import NotAuthorized
from nose.tools import assert_raises
import ckan.tests.factories as factories
from ckan import model
import ckan.tests.helpers as helpers
import ckanext.ggauth.tests.factories as authfactory
from ckan.lib import helpers as h

class TestAuthCheck(utils.baseTest):

    @classmethod
    def create_orgs(self):
        data = super(TestAuthCheck, self).create_orgs()
        dataset_id = data["dataset"]["id"]
        data["new_resource"] = factories.Resource(
                               package_id=dataset_id,
                               download="Public",
                               schema="On Request",
                               preview="Private"
                            )
        return data

    def setup(self):
        self.clean_authorizations()
        super(TestAuthCheck, self).setup()

    def test_can_see_public(self):
        context = {'model': model}
        for user in [self.data["admin_first"], self.data["user_sec"]]:
            context["user"] = user["name"]
            helpers.call_auth('resource_download', context,
                              resource_id=self.data["new_resource"]["id"])

    def test_can_see_private(self):
        context = {'model': model}
        resource = {"resource_id": self.data["new_resource"]["id"]}
        for user in [self.data["admin_first"], self.data["user_first"]]:
            self.login(user["id"])
            context["user"] = user["name"]
            helpers.call_auth('resource_on_request',
                              context=context, **resource)

    def test_cannot_see_private(self):
        context = {'model': model}
        resource = {"resource_id": self.data["new_resource"]["id"]}
        for user in [self.data["admin_sec"], self.data["user_sec"]]:
            self.login(user["id"])
            context["user"] = user["name"]
            assert_raises(
                NotAuthorized,
                helpers.call_auth,
                'resource_on_request', context=context,
                **resource
                )

    def test_cannot_see_on_request(self):
        context = {'model': model}
        resource = {"resource_id": self.data["new_resource"]["id"]}
        for user in [self.data["admin_sec"], self.data["user_sec"]]:
            self.login(user["id"])
            context["user"] = user["name"]
            assert_raises(
                NotAuthorized,
                helpers.call_auth,
                'resource_schema', context=context,
                **resource
                )

    def test_can_see_on_request(self):
        context = {'model': model}
        resource = {"resource_id": self.data["new_resource"]["id"]}

        # Default is APPROVED
        authfactory.Authorization(
            resource_id=resource["resource_id"],
            org_name=self.data["owner_org_sec"]["name"])

        for user in [self.data["admin_sec"],  self.data["user_sec"]]:
            self.login(user["id"])
            context["user"] = user["name"]
            helpers.call_auth('resource_schema',
                              context=context, **resource)
