
from ontario.common.parser import queryParser as qp
from ontario.wrapper.mapping.RMLMapping import *
from ontario.wrapper.helpers import *
from pymongo import MongoClient


class MongoDBWrapper(object):

    def __init__(self, molecule, query, config, mongourl=None):
        self.molecule = molecule
        self.query = qp.parse(query)
        self.config = config.wrappers['MongoDB']
        self.mappingfile = os.path.join(config.mappingFolder, self.config['mappingfile'])
        self.mapping = RMLMapping(self.mappingfile).getMapping(self.molecule)
        if self.config['url'] is not None and len(self.config['url']) > 0:
            self.client = MongoClient(self.config['url'])
        elif mongourl is not None:
            self.client = MongoClient(mongourl)
        else:
            self.client = MongoClient("localhost:27017")
        db, collection = self.mapping[0].logicalsource.split('/')
        self.dbname = db
        self.collectionname = collection
        self.db = self.client.get_database(db)
        #subj = self.mapping[0].subjecttemplate[self.mapping[0].subjecttemplate.find('{') + 1: self.mapping[0].subjecttemplate.find('}')]
        self.collection = self.db.get_collection(collection)

    def getGrouping(self, subjectColumn, unwind, predmap, sparqlprojected):
        group = {'_id': '$'+subjectColumn, subjectColumn:{'$addToSet': '$' + subjectColumn}}
        #{ $group: { _id:'$product', productFeature:{$addToSet:'$productFeature'}}}
        for uw in unwind:
            group[uw] = {'$addToSet': '$' + uw}

        for p in predmap:
            if predmap[p] in unwind:
                continue
            group[predmap[p]] = {'$addToSet': '$' + predmap[p]}

        return group

    def getProjections(self, triplepatterns, vartoColumnMap, maxnumofobj , sparqlprojected):

        projections = {}
        for var in sparqlprojected:
            if var in vartoColumnMap:
                column = vartoColumnMap[var]
                projections[var[1:]] = '$' + column

            else:
                print 'no mapping for', sparqlprojected, var

        return projections

    def getNotNULLs(self, predvars, predmap, sparqlprojected):
        nnull = []
        for v in predvars:
            if v[0] not in predmap:
                continue

            if v[2] not in sparqlprojected:
                #{$and: [{productPropertyNumeric4:{$ne:null}}, {productPropertyNumeric4:{$ne:''}}]}
                nn = {predmap[v[0]]: {'$ne': 'null'}}
                nmpty = {predmap[v[0]]: {'$ne': ''}}
                nnull.append(nn)
                nnull.append(nmpty)

        return nnull

    def getFiltermaps(self, filters, sparlfilters, predmap, arrayop, predobjmap):
        filtersmap = {}
        match = {}
        unwind = []
        for f in filters:
            if f[0] not in predmap:
                continue
            if f[0] in filtersmap:
                filtersmap[f[0]].append(f[2])
            else:
                filtersmap[f[0]] = [f[2]]

        for v in filtersmap:
            val = filtersmap[v]
            if len(val) > 1:
                match[predmap[v]] = {arrayop: list(set(val))}
                unwind.append(predmap[v])
            else:
                match[predmap[v]] = val[0]
        sparqlfiltered = self.getFilters(sparlfilters, predmap, predobjmap)
        for f in sparqlfiltered:
            match[f] = sparqlfiltered[f]
        '''for f in sparqlfiltered:
            if f in mquery:
                if type(mquery[f]) == dict:
                    if type(sparqlfilters[f]) == dict:
                        mquery[f].update(sparqlfilters[f])
                    else:
                        mquery[f]["$in"].append(sparqlfilters[f])
                else:
                    if type(sparqlfilters[f]) == dict:
                        mquery[f] = {"$eq": mquery[f]}
                        mquery[f].update(sparqlfilters[f])
                    else:
                        mquery[f] = {"$in": [mquery[f]]}
                        mquery[f]["$in"].append(sparqlfilters[f])
            else:
                mquery[f] = sparqlfilters[f]
        '''

        return match, list(set(unwind))

    def getMatching(self, triplepatterns, filters, sparlfilters, predmap, ifilters, sparqlprojected, arrayop='$in'):
        match = {}
        #If predicate is constant and object is a variable
        predvars = [(t.predicate.name[1:-1], " = ", t.theobject.name)
                    for t in triplepatterns if t.predicate.constant and not t.theobject.constant]

        if len(filters) == 0 and len(predvars) == 0:
            return None

        nnull = self.getNotNULLs(predvars, predmap, sparqlprojected)

        predobjmap = {}
        for t in triplepatterns:
            if not t.subject.constant:
                predobjmap[t.subject.name] = t.subject.name
            if t.predicate.constant and not t.theobject.constant:
                predobjmap[t.predicate.name[1:-1]] = t.theobject.name

        match, unwind = self.getFiltermaps(filters, sparlfilters, predmap, arrayop, predobjmap)
        # IF subject is constant
        if len(ifilters) > 0:
            match[ifilters[0][0]] = ifilters[0][2]

        if len(nnull) > 0:
            match['$and'] = nnull

        return match, unwind

    def rewrite(self, sparql):

        triplepatterns, filters, optionals = self.decomposeQuery(sparql)

        qmap = []
        predobjmap = {}
        objpredmap = {}
        filtermap = {}
        predmap = {}
        mquery = {}
        cmpquery = {}
        mproj = {}
        for t in triplepatterns:
            if t.subject.constant:
                filtermap[self.mapping[0].subjecttemplate[1:-1]] = t.subject.name[1:-1]
            else:
                predobjmap[t.subject.name] = t.subject.name
                predmap[t.subject.name] = self.mapping[0].subjecttemplate[1:-1]
                #mproj[t.subject.name] = "$"+self.mapping[0].subjecttemplate[1:-1]

            if t.predicate.constant:

                if t.theobject.constant:
                    if "<" in t.theobject.name and '>' in t.theobject.name:
                        value = str(t.theobject.name[1:-1])
                    else:
                        value = str(t.theobject.name.replace('"', ''))

                    if t.predicate.name in filtermap:
                        if type(filtermap[t.predicate.name]) == dict:
                            filtermap[t.predicate.name]["$in"].append(value)
                        else:
                            filtermap[t.predicate.name] = {"$in": [filtermap[t.predicate.name]]}
                            filtermap[t.predicate.name]["$in"].append(value)
                    else:
                        filtermap[t.predicate.name] = value
                else:
                    predobjmap[t.predicate.name] = t.theobject.name
                    if t.theobject.name in objpredmap:
                        if type(objpredmap[t.theobject.name]) == list:
                            objpredmap[t.theobject.name].append(t.predicate.name)
                        else:
                            objpredmap[t.theobject.name] = [objpredmap[t.theobject.name]]
                            objpredmap[t.theobject.name].append(t.predicate.name)
                    else:
                        objpredmap[t.theobject.name] = t.predicate.name
                qmap.append(t.predicate.name)

        for p in self.mapping[0].predicates:
            if p.predicate in qmap:
                if (p.predicate, p.refmap.name) not in predmap:
                    predmap[p.predicate] = p.refmap.name

        if self.mapping[0].subjecttemplate[1:-1] in filtermap:
            mquery[self.mapping[0].subjecttemplate[1:-1]] = filtermap[self.mapping[0].subjecttemplate[1:-1]]
        args = [a.name for a in sparql.args]

        for k in predmap:
            v = predmap[k]
            if k in filtermap:
                mquery[v] = filtermap[k]
            if k in predobjmap and predobjmap[k] in args:
                mproj[predobjmap[k][1:]] = "$" + v

            if k in predobjmap and predobjmap[k] in objpredmap and type(objpredmap[predobjmap[k]]) == list:
                cm = {'$cmp': []}
                for o in objpredmap[predobjmap[k]]:
                    cm['$cmp'].append("$" + predmap[o])
                mproj['cmp_'+predobjmap[k][1:]] = cm

                cmpquery['cmp_'+predobjmap[k][1:]] = 0

        sparqlfilters = self.getFilters(filters, predmap, predobjmap)

        for f in sparqlfilters:
            if f in mquery:
                if type(mquery[f]) == dict:
                    if type(sparqlfilters[f]) == dict:
                        mquery[f].update(sparqlfilters[f])
                    else:
                        mquery[f]["$in"].append(sparqlfilters[f])
                else:
                    if type(sparqlfilters[f]) == dict:
                        mquery[f] = {"$eq": mquery[f]}
                        mquery[f].update(sparqlfilters[f])
                    else:
                        mquery[f] = {"$in": [mquery[f]]}
                        mquery[f]["$in"].append(sparqlfilters[f])
            else:
                mquery[f] = sparqlfilters[f]

        return mquery, mproj, cmpquery

    def getFilters(self, filters, predmap, predobjmap):
        fquery = {}

        for f in filters:
            r = ""
            l = ""
            if isinstance(f.expr.left, Argument) and isinstance(f.expr.right, Argument):
                left = f.expr.left
                if left.constant:
                    if "<" in left.name:
                        left = "'" + left.name[1:-1] + "'"
                    else:
                        left = left.name
                    r = left
                else:
                    left = left.name
                    l = left

                right = f.expr.right
                if right.constant:
                    if "<" in right.name:
                        right = "'" + right.name[1:-1] + "'"
                    else:
                        right = right.name
                    r = right
                else:
                    right = right.name
                    l = right
                if "'" not in r and '"' not in r:
                    r = int(r)
                else:
                    r = r.replace('"', '').replace("'", '')
                op = "$eq"
                if f.expr.op == '>':
                    op = "$gt"
                elif f.expr.op == '<':
                    op = "$lt"
                elif f.expr.op == '>=':
                    op = "$gte"
                elif f.expr.op == '<=':
                    op = "$lte"
                elif f.expr.op == '!=':
                    op = "$ne"

                for k in predobjmap:
                    v = predobjmap[k]
                    if v == l:
                        for kk in predmap:
                            vv = predmap[kk]
                            if k == kk:
                                if op == "$eq":
                                    fquery[vv] = r
                                else:
                                    fquery[vv] = {op: r}

        return fquery

    def decomposeQuery(self, query):
        """
        decomposes a query to set of Triples and set of Filters
        :param query: sparql
        :return: triple composed of triplepatters, filters and optional
        """
        tp = []
        filters = []
        opts = []
        for b in query.body.triples:  # UnionBlock
            if isinstance(b, JoinBlock):
                for j in b.triples:  # JoinBlock
                    if isinstance(j, Triple):
                        if j.subject.constant:
                            j.subject.name = getUri(j.subject, getPrefs(query.prefs))
                        if j.predicate.constant:
                            j.predicate.name = getUri(j.predicate, getPrefs(query.prefs))
                        if j.theobject.constant:
                            j.theobject.name = getUri(j.theobject, getPrefs(query.prefs))
                        tp.append(j)
                    if isinstance(j, Filter):
                        filters.append(j)
                    elif isinstance(j, Optional):
                        opts.append(j)
        return tp, filters, opts

    def rewitertomongo(self, query):
        triplepatterns, sparqlfilters, optionals = self.decomposeQuery(query)
        pipeline = []
        mapping = self.mapping[0]
        varotColumnMap = vartocolumnmapping(mapping, triplepatterns)
        sparqlprojected = [c.name for c in query.args]
        subjectColumn = mapping.subjecttemplate[
                        mapping.subjecttemplate.find('{') + 1: mapping.subjecttemplate.find('}')]
        ids = [t.subject.name for t in triplepatterns if t.subject.constant]
        ifilters = []
        if len(ids) > 0:
            ifilters = [(subjectColumn, " = ", i[1:-1]) for i in set(ids)]

        # IF predicate + object are constants
        filters = [(t.predicate.name[1:-1], " = ", t.theobject.name[1:-1])
                   for t in triplepatterns if t.predicate.constant and t.theobject.constant]

        predmap = {t.predicate[1:-1]: t.refmap.name for t in self.mapping[0].predicates}

        predobjdict, needselfjoin, maxnumofobj = getPredObjDict(triplepatterns, varotColumnMap)
        projections = self.getProjections(triplepatterns, varotColumnMap, maxnumofobj, sparqlprojected)
        projections["_id"] = 0

        if maxnumofobj > 1:
            ormatch, unwind = self.getMatching(triplepatterns, filters, sparqlfilters, predmap, ifilters, sparqlprojected)
            grouping = self.getGrouping(subjectColumn, unwind, predmap,sparqlprojected)
            andmatch, unwind = self.getMatching(triplepatterns, filters, sparqlfilters, predmap, ifilters, sparqlprojected, "$all")

            pipeline.append({'$match': ormatch})
            pipeline.append({'$group': grouping})
            pipeline.append({'$match': andmatch})
            xunwind = {}
            xunwind['path'] = "$" + subjectColumn
            xunwind['preserveNullAndEmptyArrays'] = True
            pipeline.append({'$unwind': xunwind})
            for p in predmap:
                xunwind = {}
                xunwind['path'] = "$" + predmap[p]
                xunwind['preserveNullAndEmptyArrays'] = True
                pipeline.append({'$unwind':xunwind})
            pipeline.append({'$project': projections})
        else:
            match, unwind = self.getMatching(triplepatterns, filters, sparqlfilters, predmap, ifilters, sparqlprojected)
            if len(match) > 0:
                pipeline.append({'$match': match})

            pipeline.append({'$project': projections})

        return pipeline

    def executeQuery(self, sparql=None, limit=-1, offset=-1):
        if limit > -1 or offset > -1:
            self.query.limit = limit
            self.query.offset = offset
        if sparql:
            self.query = sparql
        else:
            sparql = self.query

        pipeline = self.rewitertomongo(sparql)
        '''mquery, mproj, cmpquery = self.rewrite(sparql)
        mproj["_id"] = 0

        pipeline = []
        if len(mquery) > 0:
            pipeline.append({"$match": mquery})

        pipeline.append({"$project": mproj})
        '''
        if sparql.limit > 0:
            if sparql.offset > 0:
                pipeline.append({"$limit": int(sparql.limit) + int(sparql.offset)})
                pipeline.append({"$skip": int(sparql.offset)})
            else:
                pipeline.append({"$limit": int(sparql.limit)})

        result = self.collection.aggregate(pipeline, useCursor=True, batchSize=1000, allowDiskUse=True)

        return result


if __name__ == "__main__":
    b1 = """
            PREFIX bsbm-inst: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/>
            PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            SELECT DISTINCT ?product ?value1
            WHERE {
                ?product bsbm:productFeature <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductFeature34439> .
                ?product bsbm:productPropertyNumeric1 ?value1 .
                ?product bsbm:productFeature <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductFeature892> .
                ?product <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductType1446>
                FILTER (?value1 > 136)
            }
        """
    b4 = """
            PREFIX bsbm-inst: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/>
            PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            SELECT DISTINCT ?product ?label
            WHERE {
            ?product rdfs:label ?label .
            ?product rdf:type <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductType109> .
            ?product bsbm:productFeature <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductFeature3407> .
            ?product bsbm:productFeature <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/ProductFeature3406> .
            ?product bsbm:productPropertyNumeric1 ?p1 .
            FILTER ( ?p1 > 137 )

            }
        """

    query = '''
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX rev: <http://purl.org/stuff/rev#>
        PREFIX foaf: <http://xmlns.com/foaf/0.1/>
        PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
        PREFIX dc: <http://purl.org/dc/elements/1.1/>
        SELECT ?reviewer ?revPublisher
        WHERE {
        ?reviewer a <http://xmlns.com/foaf/0.1/Person>.
        ?reviewer dc:date "2008-09-05" .
        ?reviewer dc:publisher ?revPublisher
        } limit 10
    '''
    sw = MongoDBWrapper("http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/Product", b1, "/home/eism25/git/Ontario/mappings")
    #sw.rewrite(query)
    cur = sw.executeQuery()

    for d in cur:
        print d