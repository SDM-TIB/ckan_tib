import ckan.lib.base as base
from logging import getLogger
import psycopg2
from ontario.wrapper.mapping.RMLMapping import *
import json
request = base.request
log = getLogger(__name__)

#SELECT description, attname from pg_description join pg_class on pg_description.objoid = pg_class.oid join pg_attribute ON (pg_attribute.attnum = pg_description.objsubid AND pg_attribute.attrelid = pg_class.oid) where relname='a7797185-d077-4ad7-a239-7211c0da48d9'

#sudo -u postgres -i psql -U ckan -W ckan -h 172.18.0.3 -p 5432 -d datastore_default -c ""
class WrapperController(base.BaseController):

	def receive_query(self, resourceId):
		sparql_query_string = request.params.get("query")
		mapping = self.getResourceMappings(resourceId)

	def getResourceMappings(self, resourceid):
		#resourceid = "a7797185-d077-4ad7-a239-7211c0da48d9"
		log.info("at least did load the get mappings")
		connection = psycopg2.connect(host="172.18.0.3", port="5432", database="datastore_default", user="ckan", password="ckan")
		cursor = connection.cursor()
		query = "SELECT description, attname from pg_description join pg_class on pg_description.objoid = pg_class.oid "
		query += "join pg_attribute ON (pg_attribute.attnum = pg_description.objsubid AND pg_attribute.attrelid = pg_class.oid)"
		query += " where relname='"+ str(resourceid) + "'"
		cursor.execute(query)
		response = cursor.fetchall()
		cursor.close()
		connection.close()
		predicatemaps = []
		for res in response:
			## the server answers with tuples that contains "description", "attribute names"
			res_dict = json.loads(res[0])
			res_dict['reference_name'] = res[1]
			#build the predicate mappings
			predicatemaps.append(self.makePredicateMap(res_dict)) 
			#build the subject mappings
		

	def makePredicateMap(self, description):
		description['map'] = description['map'].split(":")
		prefix = None
		if len(description['map']) > 1:
			prefix = description['map'][1]
		refmap = ReferenceMap(description['reference_name'], description['type_override'])
		PredicateMap = RMLPredicate(description['map'][0], refmap, prefix)
		return PredicateMap