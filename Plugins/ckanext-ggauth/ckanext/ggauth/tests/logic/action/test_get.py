import ckan.tests.factories as factories
import ckanext.ggauth.tests.utils as utils
import ckanext.ggauth.model as authmodel
import ckan.tests.helpers as helpers
from nose.tools import assert_raises
from ckan.logic import NotFound, NotAuthorized, get_action


class TestGet(utils.baseTest):

    def test_permission_get_wrong(self):
        for r, o in [(self.resource_id, "random"),
                     ("random", "random")]:
            assert_raises(NotFound,
                          helpers.call_action,
                          'permission_get',
                          resource_id=r,
                          org_name=o)

    def test_permission_get_working(self):
        result = helpers.call_action('permission_get',
                                     resource_id=self.resource_id,
                                     org_name=self.org_name)
        assert(result.download == authmodel.StatusClass.APPROVED.value)
        assert(result.schema == authmodel.StatusClass.APPROVED.value)
        assert(result.preview == authmodel.StatusClass.APPROVED.value)

    def test_permission_get_with_auth_not_belong_org(self):
        # Another org, no org, not logged in
        random_user = factories.User()
        random_user2 = factories.User()
        random_user3 = None

        factories.Organization(
            users=[{'name': random_user['id'], 'capacity': 'admin'}]
        )

        for user in [random_user["id"], random_user2["id"], random_user3]:
            self.login(user)

            data = {"resource_id": self.resource_id,
                    "org_name": self.org_name,
                    "id": self.package_id}

            with assert_raises(NotAuthorized):
                get_action('permission_get')({}, data)

    def test_permission_get_with_auth_belong_org(self):
        # Data owner, and permission requester
        valid_id = self.data["admin_first"]["id"]
        valid_id2 = self.data["user_sec"]["id"]

        for id in [valid_id, valid_id2]:
            self.login(id)
            get_action('permission_get')({},
                                         {"resource_id": self.resource_id,
                                          "org_name": self.org_name,
                                          "id": self.package_id})

    def test_permission_list_auth(self):
        valid_id = self.data["admin_first"]["id"]

        self.login(valid_id)

        get_action('permission_list')({},
                                      {"id": self.resource_id})

    def test_permission_list_auth_not_org_owner_admin(self):
        wrong_id = self.data["user_sec"]["id"]
        wrong_id2 = self.data["user_first"]["id"]

        for id in [wrong_id, wrong_id2]:
            self.login(id)
            with assert_raises(NotAuthorized):
                get_action('permission_list')({},
                                              {"id": self.resource_id})
