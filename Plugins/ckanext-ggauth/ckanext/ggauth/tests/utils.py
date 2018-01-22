import ckan.model as model
import ckan.tests.factories as factories
import ckanext.ggauth.tests.factories as authfactory
import ckan.tests.helpers as helpers


class baseTest(object):

    @classmethod
    def setup_class(cls):
        cls.clean_authorizations()
        model.repo.rebuild_db()
        cls.app = helpers._get_test_app()

        cls.data = cls.create_orgs()
        cls.resource_id = cls.data["resource"]["id"]
        cls.package_id = cls.data["resource"]["package_id"]
        cls.org_name = cls.data["owner_org_sec"]["name"]
        cls.session = model.meta.Session()

        authfactory.Authorization(resource_id=cls.data["resource"]["id"],
                                  org_name=cls.data["owner_org_sec"]["name"])

    def setup(self):
        self.request_context = self.app.flask_app.test_request_context()
        self.request_context.push()

    def teardown(self):
        self.request_context.pop()

    @staticmethod
    def clean_authorizations():
        session = model.meta.Session()
        connection = session.connection()
        connection.execute('delete from "%s"' % "authorization")
        session.commit()

    def login(self, user_id):
        if user_id:
            userobj = self.session.query(model.User).get(user_id)

            self.request_context.g.userobj = userobj
            self.request_context.g.user = userobj.name
        else:
            self.request_context.g.userobj = None
            self.request_context.g.user = None

    @classmethod
    def create_orgs(self):
        data = {}
        data["admin_first"] = factories.User(name="dataowner-admin")
        data["user_first"] = factories.User(name="dataowner-user")

        data["owner_org"] = factories.Organization(
            users=[{'name': data["admin_first"]['id'], 'capacity': 'admin'},
                   {'name': data["user_first"]['id'], 'capacity': 'member'}]
        )
        data["dataset"] = factories.Dataset(owner_org=data["owner_org"]['id'])
        data["resource"] = factories.Resource(package_id=data["dataset"]['id'])

        data["admin_sec"] = factories.User(name="databuyer-admin")
        data["user_sec"] = factories.User(name="databuyer-user")
        data["owner_org_sec"] = factories.Organization(
            users=[{'name': data["admin_sec"]['id'], 'capacity': 'admin'},
                   {'name': data["user_sec"]['id'], 'capacity': 'member'},
                   ]
        )
        return data

    @classmethod
    def create_random_org(self):
        self.data["random_org"] = factories.Organization(
            users=[{'name': self.data["user_sec"]['id'], 'capacity': 'member'}] )
