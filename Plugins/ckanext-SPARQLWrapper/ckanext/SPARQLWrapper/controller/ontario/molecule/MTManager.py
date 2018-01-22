
__author__ = 'kemele'
from pyArango.connection import *
import abc
import json


class Config(object):
    def __init__(self, configfile):
        self.configfile = configfile
        self.metadata = self.getAll()

    @abc.abstractmethod
    def getAll(self):
        return

    def findbypreds(self, preds):
        mols = []
        for m in self.metadata:
            found = True
            for p in preds:
                mps = [pm['predicate'] for pm in self.metadata[m]['predicates']]
                if p not in mps:
                    found = False
                    break
            if found:
                mols.append(m)
        return mols

    def findbypred(self, pred):
        mols = []
        for m in self.metadata:
            mps = [pm['predicate'] for pm in self.metadata[m]['predicates']]
            if pred in mps:
                mols.append(m)
        return mols

    def findMolecule(self, molecule):
        if molecule in self.metadata:
            return self.metadata[molecule]
        else:
            return None


class ArangoConfig(object):
    def __init__(self, url, database="OntarioMoleculeTemplates", moleculesCollection="MoleculeTemplates",
                 secured=False, username="", password=""):
        self.url = url
        self.database = database
        self.mtsCollection = moleculesCollection
        self.secured = secured
        self.username = username
        self.password = password

    def __repr__(self):
        return self.url

class ConfigFile(Config):

    def getAll(self):
        return self.readJsonFile(self.configfile)

    def readJsonFile(self, configfile):
        with open(configfile) as f:
            conf = json.load(f)
        with open(conf['filepath']['path']) as f:
            mts = json.load(f)
        meta = {}
        for m in mts:
            meta[m['rootType']] = m
        return meta


class Arango(Config):
    """
    Creates a configuration object for molecule templates
    """
    def getAll(self):
        conn, config = self.getArangoDB(self.configfile)

        '''
        Load everything from molecule templates catalog
        :return: list of all molecule templates in the database
        '''
        db = conn[config.database]
        molquery = 'FOR u IN ' + config.mtsCollection + ' RETURN u'
        mtResult = db.AQLQuery(molquery, rawResults=True, batchSize=2000, bindVars={})
        mts = mtResult.response['result']
        meta = {}
        for m in mts:
            meta[m['rootType']] = m
        return meta

    def getArangoDB(self, configfile):
        '''
        Read arangodb connection and configuration from config json file
        :param configfile: json file specifying arangodb server info and database information:
            e.g.,  arangodb: {url: "", database: "", MTsCollection: "", secured:"True/False", username: "", password: ""}
        :return: connection and ArangoConfig objects
        '''
        conff = self.loadArangoConfig(configfile)
        if conff.secured:
            conns = Connection(arangoURL=conff.url, username=conff.username, password=conff.password)
        else:
            conns = Connection(arangoURL=conff.url)
        return conns, conff

    def loadArangoConfig(self, configfile):
        '''
        Loads configuration from json file
        :param configfile:
           e.g.,  arangodb: {url: "", database: "", MTsCollection: "", secured:"True/False", username: "", password: ""}
        :return: ArangoConfig object
        '''
        with open(configfile) as mfile:
            config = json.load(mfile)
        config = config['arangodb']
        conff = ArangoConfig(config['url'], config['database'], config['MTsCollection'], config['secured'],
                             config['username'], config['password'])
        return conff


if __name__ == "__main__":
    print "hello"
    arr = ConfigFile("/home/kemele/git/Ontario/config/bsbm.json")
    print "initialized"
    preds = ["http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/productPropertyNumeric1", "http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/productFeature"]
    print arr.findbypreds(preds)
    exit()
    for t in arr.metadata:
        print t
        print "\t", arr.metadata[t]['linkedTo']
        print '\t', arr.metadata[t]['predicates']
        print '\t', arr.metadata[t]['wrappers']
    print len(arr.metadata)
