import logging

import ckan.model as model
from ckan.lib.cli import CkanCommand

class AuthCommand(CkanCommand):

    ''' Perform tasks on the database to allow Authorization plugin to work.

    auth_command init                        - create tables needed
    auth_command delete-auth                 - removes auth tables (including dropping tables)

    '''
    summary = __doc__.split('\n')[0]
    usage = __doc__
    max_args = None
    min_args = 1

    def __init__(self, name):
         super(AuthCommand, self).__init__(name)

    def command(self):

        self._load_config()

        model.Session.remove()
        model.Session.configure(bind=model.meta.engine)

        self.log = logging.getLogger(__name__)

        if not self.args or self.args[0] in ['--help', '-h', 'help']:
            print self.usage
            sys.exit(1)

        cmd = self.args[0]

        if cmd == 'init':
            from ckanext.ggauth.model import init_tables
            init_tables(model.meta.engine)
        elif cmd == 'delete-auth':
            from ckanext.ggauth.model import destroy_tables
            destroy_tables(model.meta.engine)
        else :
            self.log.error('Command %s not recognized' % (cmd,))
            sys.exit(1)
