
import json
from pyArango.connection import *
import abc


class Config(object):
    @abc.abstractmethod
    def getMolecules(self):
        return



class ArangoConfig(object):
    def __init__(self, url, database="OntarioMeta", moleculesCollection="molecules", templateCollection="templates", \
                 wrapperDescriptionCollection="wrapperDesc", secured=False, username="", password="", ):
        self.url = url
        self.database = database
        self.wrapperDescriptionCollection = wrapperDescriptionCollection
        self.moleculesCollection = moleculesCollection
        self.templateCollection = templateCollection
        self.secured = secured
        self.username = username
        self.password = password

    def __repr__(self):
        return self.url


class Arango(object):

    def __init__(self, conn=None, config=None):
        self.conn = conn
        self.config = config
        self.metadata = self.getAll()

    def initialize(self, configfile):
        conns, conff = Arango.getArangoDB(configfile)
        self.conn = conns
        self.config = conff
        return self

    def getAll(self):
        db = self.conn[self.config.database]
        tempquery = 'FOR u IN ' + self.config.templateCollection  + ' RETURN {domain: u.domain, predicate:u.predicate, range:u.range}'
        tempqueryResult = db.AQLQuery(tempquery, rawResults=True, batchSize=2000, bindVars={})

        molquery = 'FOR u IN ' + self.config.moleculesCollection + ' RETURN {rootType: u.rootType, linkedTo:u.linkedTo, predicates:u.predicates}'
        molqueryResult = db.AQLQuery(molquery, rawResults=True, batchSize=2000, bindVars={})

        wrquery = 'FOR u IN ' + self.config.wrapperDescriptionCollection + ' RETURN {rootType: u.rootType, url:u.url, wrapperType:u.wrapperType, ' \
                                                       'urlparam:u.urlparam, linkedTo:u.linkedTo, predicates:u.predicates}'
        wrqeuryResult = db.AQLQuery(wrquery, rawResults=True, batchSize=2000, bindVars={})
        temps = tempqueryResult.response['result']
        temp = {}
        for t in temps:
            temp[t['predicate']] = t
        metadata = {"templates": temp, "molecules": molqueryResult.response['result'], "wrappers": wrqeuryResult.response['result']}

        return metadata

    def getbytype(self, rootType):
        return [m for m in self.metadata['molecules'] if m['rootType'] == rootType]

    def getByType(self, rootType):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@molecules'
        filters = None
        if rootType is not None:
            filters = " u.rootType == @rootType"
            mpping['rootType'] = rootType
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@molecules'] = self.config.moleculesCollection

        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def findbypreds(self, preds):
        mols = []
        for m in self.metadata['molecules']:
            found = True
            for p in preds:
                if p not in m['predicates']:
                    found = False
                    break
            if found:
                mols.append(m)
        return mols
        #return [m for m in self.metadata['molecules'] for p in preds if p in m['predicates']]

    def findAllMolecules(self):
        return self.metadata['molecules']

    def findbypredss(self, preds):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@molecules'
        filters = None
        i = 0
        if preds is not None and isinstance(preds, list):
            for pred in preds:
                if i == 0:
                    filters = "  @pred0 IN u.predicates[*] "
                else:
                    filters += " AND @pred" + str(i) + " IN u.predicates[*] "
                mpping['pred'+str(i)] = pred
                i += 1
        else:
            return []
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@molecules'] = self.config.moleculesCollection
        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def findbytemp(self, pred):
        db = self.conn[self.config.database]
        mpping  = {}
        query = 'FOR u IN @@molecules'
        filters = None
        if pred is not None:
            filters = "  @pred IN u.predicates[*]"
            mpping['pred'] = pred
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@molecules'] = self.config.moleculesCollection
        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def findTemp(self, pred):
        if pred in self.metadata['templates']:
            return self.metadata['templates'][pred]
        else:
            return []
        #return [m for m in self.metadata['templates'] if pred == m['predicate']]

    def findTemps(self, pred):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@templates'
        filters = None
        if pred is not None:
            filters = " u.predicate == @pred "
            mpping['pred'] = pred
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {domain: u.domain, predicate:u.predicate, range:u.range}'
        mpping['@templates'] = self.config.templateCollection
        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def getWrappers(self, rootType):
        return [m for m in self.metadata['wrappers'] if m['rootType'] == rootType]

    def getWrapperss(self, rootType):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@wrappers'
        filters = None
        if rootType is not None:
            filters = " u.rootType == @rootType"
            mpping['rootType'] = rootType
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, url:u.url, wrapperType:u.wrapperType, ' \
                 'urlparam:u.urlparam, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@wrappers'] = self.config.wrapperDescriptionCollection
        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def getWrapperswizpred(self, rootType, preds):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@wrappers'
        filters = None
        if rootType is not None:
            filters = " u.rootType == @rootType"
            mpping['rootType'] = rootType
        i = 0
        if preds is not None and isinstance(preds, list):
            for pred in preds:
                if i == 0:
                    filters = "  @pred0 IN u.predicates[*] "
                else:
                    filters += " AND @pred" + str(i) + " IN u.predicates[*] "
                mpping['pred' + str(i)] = pred
                i += 1
        else:
            return []
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, url:u.url, wrapperType:u.wrapperType, ' \
                 'urlparam:u.urlparam, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@wrappers'] = self.config.wrapperDescriptionCollection
        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def getWrappershaspreds(self, rootType, preds):
        mols = []
        for m in self.metadata['wrappers']:
            if m['rootType'] != rootType:
                continue
            found = True
            for p in preds:
                if p not in m['predicates']:
                    found = False
                    break
            if found:
                mols.append(m)
        return mols

        #return [m for m in self.metadata['wrappers'] for p in preds if m['rootType'] == rootType and p in m['predicates']]

    def getWrappershaspredss(self, rootType, preds):
        db = self.conn[self.config.database]
        mpping = {}
        query = 'FOR u IN @@wrappers'
        filters = None
        if rootType is not None:
            filters = " u.rootType == @rootType"
            mpping['rootType'] = rootType
        i = 0
        if preds is not None and isinstance(preds, list):
            for pred in preds:
                if i == 0:
                    filters += " AND (@pred0 IN u.predicates[*] "
                else:
                    filters += " AND @pred" + str(i) + " IN u.predicates[*] "
                mpping['pred' + str(i)] = pred
                i += 1
            if i > 0:
                filters += ' ) '
        else:
            return []
        if filters is not None:
            query += " FILTER " + filters
        query += ' RETURN {rootType: u.rootType, url:u.url, wrapperType:u.wrapperType, ' \
                 'urlparam:u.urlparam, linkedTo:u.linkedTo, predicates:u.predicates}'
        mpping['@wrappers'] = self.config.wrapperDescriptionCollection

        queryResult = db.AQLQuery(query, rawResults=True, batchSize=1000, bindVars=mpping)

        return queryResult

    def findmolecule(self, ID=None, root=None, metaWrapper=None, pred=None, link=None):
        query = '''FOR u IN @@molecules
            FILTER  @pred IN u.templates[*]
            RETURN { root: u.rootType, metaWrapper:u.metaWrapper, predicates:u.predicates}'''
        query = "FOR m IN  @@molecules "
        filters = None
        mpping = {}
        if ID is not None:
            filters = " m.ID == @ID" if filters is None else filters + " AND m.ID == @ID"
            mpping['ID'] = ID
        if root is not None:
            filters = " m.rootType == @root"  if filters is None else filters + " AND m.rootType == @root"
            mpping['root'] = root
        if metaWrapper is not None:
            filters = " m.metaWrapper == @metaWrapper "  if filters is None else filters + " AND m.metaWrapper == @metaWrapper "
            mpping['metaWrapper'] = metaWrapper
        if pred is not None:
            filters = " @pred IN m.templates[*] " if filters is None else filters + " AND @pred IN m.templates[*] "
            mpping['pred'] = pred
        if link is not None:
            filters = " @link IN m.linkedTo[*] " if filters is None else filters + " AND @link IN m.linkedTo[*] "
            mpping['link'] = link
        if filters is not None:
            filters = " FILTER " + str(filters)
            query += str(filters)
        query += " RETURN {ID: u.ID, rootType: u.rootType, metaWrapper:u.metaWrapper, linkedTo:u.linkedTo, templates:u.templates, count: u.count}"
        print query
        print self.config.moleculesCollection
        #mapping = {'@molecules': self.config.moleculesCollection}
        mpping['@molecules'] = self.config.moleculesCollection
        db = self.conn[self.config.database]
        print db.collections
        moleculesCol = db.collections[self.config.moleculesCollection]
        print moleculesCol.name
        queryResult = db.AQLQuery(str(query), rawResults=True, batchSize=100, bindVars=mpping)

        return queryResult

    @staticmethod
    def createfrom(configfile):
        conns, conff = Arango.getArangoDB(configfile)
        return Arango(conns, conff)

    @staticmethod
    def loadArangoConfig(configfile):
        with open(configfile) as mfile:
            config = json.load(mfile)
        config = config['arangodb']
        conff = ArangoConfig(config['url'], config['database'], config['moleculesCollection'], config['templateCollection'],
                            config['wrapperDescriptionCollection'], config['secured'], config['username'], config['password'])
        return conff

    @staticmethod
    def getArangoDB(configfile):
        conff = Arango.loadArangoConfig(configfile)
        if conff.secured:
            conns = Connection(arangoURL=conff.url, username=conff.username, password=conff.password)
        else:
            conns = Connection(arangoURL=conff.url)
        return conns, conff





if __name__ == "__main__":
    cc = '://dbpedia.org/ontology/BasketballLeague>.'
    print cc.find('http')
    exit()
    arr = Arango()
    arr.initialize("/home/kemele/git/Ontario/config/config.json")
    mm = arr.findTemp("dc-date")
    print mm

    #mols = arr.findmolecule(pred="rdfs-label")
    exit()
    #for r in mols:
     #   print r['root'], "=>", r['metaWrapper']

    conn = arr.conn
    conf = arr.config
    db = conn[conf.database]
    #moleculesCol = db.collections[conf.moleculesCollection]
    query = 'FOR u IN @@molecules FILTER  @pred IN u.templates[*]  RETURN { root: u.rootType, metaWrapper:u.metaWrapper, templates:u.templates}'
    mapping = {'@molecules': conf.moleculesCollection, 'pred':'rdf-type'}
    queryResult = db.AQLQuery(query, rawResults=True, batchSize=1, bindVars=mapping)
    for r in queryResult:
        print r['root'], "=>", r['metaWrapper']
