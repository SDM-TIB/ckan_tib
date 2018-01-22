import ckan.plugins as plugins
import logging

class SparqlwrapperPlugin(plugins.SingletonPlugin):
    plugins.implements(plugins.IRoutes, inherit=True)
    plugins.implements(plugins.IConfigurer)

    def update_config(self, config):
        plugins.toolkit.add_template_directory(config, 'templates')

    #add the route for the sparql wrapper
    def before_map(self, map):
        map.connect('sparql_wrapper', '/sparqlwrapper/{resourceId}/sparql',
                    controller='ckanext.SPARQLWrapper.controller.wrapper:WrapperController',
                    action='receive_query')
        return map
