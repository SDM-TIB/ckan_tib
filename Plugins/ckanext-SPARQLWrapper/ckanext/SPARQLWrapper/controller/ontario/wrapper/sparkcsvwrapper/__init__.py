from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from py4j.java_gateway import java_import

import random
import json
from ontario.common.parser import queryParser as qp
from ontario.common.parser.services import *
from ontario.wrapper.mapping.RMLMapping import *
from ontario.wrapper.helpers import *


class OntarioCSVWrapper(object):

    def __init__(self, molecule, query, url, params, config):
        self.molecule = molecule
        self.query = qp.parse(query)
        self.url = url
        self.params = params
        self.mappingfolder = config.mappingFolder
        self.spark = None
        self.df = None
        self.config = config.wrappers['SPARKCSV']
        self.result = None

    def aggregation(self, result):
        offset = self.query.offset
        limit = self.query.limit
        if limit > 0:
            if offset > 0:
                if len(result) >= offset + limit:
                    return result[offset:offset + limit]
                elif len(result) > offset:
                    return result[offset:]
            else:
                if len(result) > limit:
                    return result[:limit]
                else:
                    return []
        else:
            return result

    def tosql(self, triplepatterns, sparqlfilters, subjectColumn, variablemap, sparqlprojected):

        ids = [t.subject.name for t in triplepatterns if t.subject.constant]
        ifilters = []
        if len(ids) > 0:
            ifilters = [(subjectColumn, " = ", i[1:-1]) for i in set(ids)]

        predobjdict, needselfjoin, maxnumofobj = getPredObjDict(triplepatterns, variablemap)
        sqlquery = ""

        '''
        If the query (SSQ) contains multiple objects with single predicate:
                  ?s   rdfs:label ?label1.
                  ?s   rdfs:label ?label2
        '''
        #if needselfjoin:
        fromcaluse = getFROMClause(subjectColumn, maxnumofobj)
        projections = getProjectionClause(variablemap, sparqlprojected, maxnumofobj)
        '''
          Case I: If subject is constant
        '''
        subjectfilters, firstfilter = getSubjectFilters(ifilters, maxnumofobj)
        '''
          Case II: If predicate + object are constants
        '''
        objectfilters, firstfilter = getObjectFilters(self.mapping, triplepatterns, subjectColumn, maxnumofobj, firstfilter, sparqlprojected)

        if len(sparqlfilters) > 0:
            simplefilters = None
            for f in sparqlfilters:
                simple = getSparqlFilters(f, self.mapping, maxnumofobj, firstfilter, variablemap)
                if simple:
                    if not simplefilters:
                        simplefilters = ""
                    simplefilters += " " + simple
        else:
            simplefilters = None

        if subjectfilters or objectfilters or simplefilters:
            whereclause = " WHERE "
            if subjectfilters:
                whereclause += subjectfilters
            if objectfilters:
                whereclause += " " + objectfilters
            if simplefilters:
                whereclause += " " + simplefilters
        else:
            whereclause = ""

        sqlquery = projections + " " + fromcaluse + " " + whereclause

        #print "final CSV query: ", sqlquery
        return sqlquery

    def run(self, query):

        triplepatterns, filters, optionals = decomposeQuery(query)
        variablemap = vartocolumnmapping(self.mapping, triplepatterns)
        a = random.randint(1, 100)
        fileName = self.mapping.logicalsource
        if not self.spark:
            url = self.config['url']
            params = self.config['params']
            self.spark = SparkSession.builder.master(url) \
                .appName("OntarioSparkCsvWrapper" + str(self.molecule) + str(a))
            for p in params:
                self.spark = self.spark.config(p, params[p])

            self.spark = self.spark.getOrCreate()

        sparqlprojected = [c.name for c in query.args]

        subjectColumn = self.mapping.subjecttemplate[self.mapping.subjecttemplate.find('{') + 1: self.mapping.subjecttemplate.find('}')]

        sqlquery = self.tosql(triplepatterns, filters, subjectColumn, variablemap, sparqlprojected)

        self.df = self.spark.read.csv(fileName, header=True)
        self.df.createOrReplaceTempView(subjectColumn)
        self.result = self.spark.sql(sqlquery).distinct().toJSON()

        #return result.toJSON().take(10000)

    def getpage(self, limit=-1, offset=-1):
        if limit > -1 or offset > -1:
            self.query.limit = limit
            self.query.offset = offset
        else:
            offset = self.query.offset
            limit = self.query.limit

        output = []
        reslen = self.result.count()
        if limit > 0:
            if offset > 0:
                if reslen >= offset + limit:
                    output = self.result.take(offset + limit)
                    return output[offset:]
                elif reslen > offset:
                    output = self.result.collect()
                    return output[offset:]
                else:
                    return []
            else:
                if reslen > limit:
                    output = self.result.take(limit)
                    return output
                else:
                    return self.result.collect()
        else:
            return self.result.take(1000000)  # Max limit

    def executeQuery(self, limit=-1, offset=-1):
        """
        Entry point for query execution on csv files
        :param querystr: string query
        :return:
        """
        if limit > -1 or offset > -1:
            self.query.limit = limit
            self.query.offset = offset
            return self.getpage(limit, offset)

        #bsbmmap = os.path.join(ontario.__path__[0], 'csvmapping.ttl')
        #bsbmmap = "/database/csvmapping.ttl"
        bsbmmap = os.path.join(self.mappingfolder, self.config['mappingfile'])
        if self.molecule:
            self.mapping = RMLMapping(bsbmmap).getMapping(self.molecule)
        else:
            self.mapping = RMLMapping(bsbmmap)
        self.mapping = self.mapping[0]

        self.run(self.query)

        result = self.getpage(self.query.limit, self.query.offset)

        return result

    def start(self, query, queue):

        triplepatterns, filters, optionals = decomposeQuery(query)
        variablemap = vartocolumnmapping(self.mapping, triplepatterns)
        a = random.randint(1, 100)
        fileName = self.mapping.logicalsource
        if not self.spark:
            url = self.config['url']
            params = self.config['params']
            self.spark = SparkSession.builder.master(url) \
                .appName("OntarioSparkCsvWrapper" + str(self.molecule) + str(a))
            for p in params:
                self.spark = self.spark.config(p, params[p])

            self.spark = self.spark.getOrCreate()

        sparqlprojected = [c.name for c in query.args]
        subjtemplate = self.mapping.subjecttemplate
        subjectColumn = subjtemplate[subjtemplate.find('{') + 1: subjtemplate.find('}')]

        sqlquery = self.tosql(triplepatterns, filters, subjectColumn, variablemap, sparqlprojected)

        self.df = self.spark.read.csv(fileName, header=True)
        self.df.createOrReplaceTempView(subjectColumn)
        self.result = self.spark.sql(sqlquery) #.toJSON()
        count = 0
        offset = self.query.offset
        limit = self.query.limit
        xoffset = 0
        xlimit = 0
        for row in self.result.toLocalIterator():
            if offset > -1 or limit > -1:
                if offset > -1 and xoffset >= offset:
                    if limit > -1 and xlimit <= limit:
                        queue.put(row.asDict(True))
                    else:
                        break
                elif offset <= -1 and limit > -1 and xlimit <= limit:
                    queue.put(row.asDict(True))

                xlimit += 1
                xoffset += 1

            else:
                queue.put(row.asDict(True))
            count += 1

        return count

    def execute(self, queue, limit=-1, offset=-1):
        """
        Entry point for query execution on csv files
        :param querystr: string query
        :return:
        """
        if limit > -1 or offset > -1:
            self.query.limit = limit
            self.query.offset = offset

        bsbmmap = os.path.join(self.mappingfolder, self.config['mappingfile'])
        if self.molecule:
            self.mapping = RMLMapping(bsbmmap).getMapping(self.molecule)
        else:
            self.mapping = RMLMapping(bsbmmap)

        self.mapping = self.mapping[0]

        cardinality = self.start(self.query, queue)

        #result = self.getpage(self.query.limit, self.query.offset)

        return cardinality