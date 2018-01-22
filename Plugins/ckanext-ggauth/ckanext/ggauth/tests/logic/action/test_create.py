import ckanext.ggauth.tests.utils as utils
import ckanext.ggauth.model as authmodel
from ckan.logic import NotAuthorized, get_action
from nose.tools import assert_raises


class TestCreate(utils.baseTest):
    def setup(self):
        self.clean_authorizations()
        super(TestCreate, self).setup()

    def default_dict(self, org_name):
        return {
                "download": authmodel.StatusClass.DENIED.value,
                "schema": authmodel.StatusClass.DENIED.value,
                "preview": authmodel.StatusClass.DENIED.value,
                "resource_id": self.data["resource"]["id"],
                "id": self.data["resource"]["package_id"],
                "org_name": org_name
            }

    def create_permission(self, org_name):
        data_dict = self.default_dict(org_name)
        get_action('permission_create')({}, data_dict)

    def ask_permission(self, org_name, data={}):
        data_dict = self.default_dict(org_name)
        if data:
            data_dict.update(data)
        get_action('permission_request')({}, data_dict)

    def test_permission_create(self):
        user = self.data["admin_first"]
        self.login(user["id"])
        for org in [self.data["owner_org"], self.data["owner_org_sec"]]:
            self.clean_authorizations()
            self.create_permission(org["name"])

    def test_permission_create_user_fail(self):
        user = self.data["user_first"]
        self.login(user["id"])
        for org in [self.data["owner_org"], self.data["owner_org_sec"]]:
            assert_raises(NotAuthorized, self.create_permission, org["name"])

    def test_permission_create_not_org_fail(self):
        user = self.data["admin_sec"]
        self.login(user["id"])
        for org in [self.data["owner_org"], self.data["owner_org_sec"]]:
            assert_raises(NotAuthorized, self.create_permission, org["name"])

    def test_permission_request_good(self):
        user = self.data["admin_sec"]
        self.login(user["id"])
        for org in [self.data["owner_org_sec"]]:
            self.ask_permission(org["name"])

    def test_permission_request_other_org(self):
        user = self.data["admin_sec"]
        self.login(user["id"])
        for org in [self.data["owner_org"]]:
            assert_raises(NotAuthorized, self.ask_permission, org["name"])

    def test_permission_request_by_user(self):
        user = self.data["user_sec"]
        self.login(user["id"])
        for org in [self.data["owner_org"], self.data["owner_org_sec"]]:
            assert_raises(NotAuthorized, self.ask_permission, org["name"])
