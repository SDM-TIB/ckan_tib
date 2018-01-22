import ckanext.ggauth.tests.utils as test_utils
from ckan.logic import NotAuthorized
from nose.tools import assert_raises

from ckan import model

import ckanext.ggauth.utils as utils

from ckan.plugins.toolkit import Invalid

class TestAuthCheck(test_utils.baseTest):
    @classmethod
    def setup_class(cls):
        super(TestAuthCheck,cls).setup_class()
        cls.create_random_org()
        cls.data_dict = {
                ('role',): 'admin',
                ('id', ): cls.data["owner_org"]["id"]
            }
        cls.key = ('role', )
        cls.context = {'model': model}


    def test_one_admin_add_second(self):
        with assert_raises(Invalid):
            utils.one_admin(self.key, self.data_dict, {}, self.context)

    def test_one_admin_add_first(self):
        # self.data_dict[('id', )] = 'random'
        # admin = utils.get_org_admin(self.context,
        #                             self.data["random_org"]["name"])
        # # print(admin)
        # # data["random_org"]["users"][0]["capacity"] = "member"
        # self.data["random_org"]["users"] = []
        # print(type(self.data["random_org"]))
        # utils.one_admin(self.key, self.data_dict, {}, self.context)
