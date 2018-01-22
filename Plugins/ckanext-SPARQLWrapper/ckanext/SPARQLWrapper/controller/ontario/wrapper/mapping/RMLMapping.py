import rdflib
__author__ = "Kemele M. Endris"


class ReferenceMap(object):
    def __init__(self, name, datatype="xsd:string", lang="en"):
        self.name = name
        self.datatype = datatype
        self.lang = lang


class RMLPredicate(object):
    def __init__(self, predicate, refmap, prefix=None, isconstant=False):
        self.predicate = predicate
        self.refmap = refmap
        self.prefix = prefix
        self.isconstant = isconstant

    def __repr__(self):
        return "\t" + self.predicate + " => " + str(self.refmap)


class RMLSubject(object):
    def __init__(self, id, logicalsource, subjecttemplate, subjectclass="rdfs:Class", predicates=[]):
        self.id = id
        self.logicalsource = logicalsource
        self.subjecttemplate = subjecttemplate
        self.subjectclass = subjectclass
        self.predicates = predicates

    def __repr__(self):
        rep = "<" + self.id + ">  rml:source " + self.logicalsource + "; rr:class " + self.subjectclass + "; \n "
        for p in self.predicates:
            rep += str(p) + ";\n"

        return rep[:-2] + ". "

    def __eq__(self, other):
        return self.id == other.id


class RMLMapping(object):

    prefix = "prefix rr: <http://www.w3.org/ns/r2rml#> " \
             "prefix rml: <http://semweb.mmlab.be/ns/rml#> " \
             "prefix ql: <http://semweb.mmlab.be/ns/ql#> " \
             "prefix bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/> "

    def __init__(self, mapfile, subjectmaps={}):
        self.mapingfile = mapfile
        self.subjectmaps = subjectmaps

    def __repr__(self):
        rep = "Mapping file: " + self.mapingfile + " \n"
        for s in self.subjectmaps:
            rep += str(s) + "\n -------------------------------------------------\n"
        return rep

    def loadAllMappings(self):
        qstr = self.prefix + " SELECT * " \
              " WHERE {" \
              "?s rml:logicalSource ?source. " \
              "?source rml:source ?sourceuri. " \
              "?s rr:subjectMap ?smap." \
              " ?smap rr:class ?subjectclass. " \
              "?s rr:predicateObjectMap ?pmap. " \
              "?pmap rr:predicate ?predicate. " \
              " ?pmap rr:objectMap ?pomap. " \
              "?pomap rml:reference ?headername " \
              " OPTIONAL{?pomap rr:datatype ?datatype}" \
              " }"
        return self.queryMappings()

    def getMapping(self, subjectclass):

        if len(self.subjectmaps) > 0:
            subjj = self.subjectmaps[subjectclass]
            #subjj = [s for s in self.subjectmaps if s.subjectclass == subjectclass]
            return subjj
        else:
            return self.queryMappings(subjectclass)

    def queryMappings(self, subjectclass=None):
        g = rdflib.Graph()
        g.load(self.mapingfile, format='n3')

        subj = "?subjectclass"
        if subjectclass:
            subj = " <" + subjectclass + "> "

        query = self.prefix + " SELECT * " \
                              " WHERE {" \
                              "?s rml:logicalSource ?source. " \
                              "?source rml:source ?sourceuri. " \
                              "?s rr:subjectMap ?smap. " \
                              "?smap rr:template ?subjtemplate. " \
                              "?smap rr:class " + subj + ". " \
                              "?s rr:predicateObjectMap ?pmap. " \
                              "?pmap rr:predicate ?predicate. " \
                              " ?pmap rr:objectMap ?pomap. " \
                              "?pomap rml:reference ?headername " \
                              " OPTIONAL{?pomap rr:datatype ?datatype } " \
                              " OPTIONAL{?pomap rr:language ?lang}" \
                              " }"
        res = g.query(query)

        for row in res:
            datatype = row.datatype
            if not datatype or len(datatype) == 0:
                datatype = "xsd:string"

            lang = row.lang
            if not lang or len(lang) == 0:
                lang = 'en'

            header = ReferenceMap(str(row.headername), str(datatype), str(lang))
            pred = RMLPredicate("<"+str(row.predicate)+">", header)

            if 'subjectclass' in row:# and row.subjectclass:
                subjectclass = row.subjectclass

            subject = RMLSubject(str(row.s), str(row.sourceuri), str(row.subjtemplate), "<"+str(subjectclass)+">", [pred])

            #subjects = [self.subjectmaps[s] for s in self.subjectmaps if s.id == str(row.s)]
            #if len(subjects) > 0:
            #    subject = subjects[0]
            #    subject.predicates.append(pred)
            if subjectclass not in self.subjectmaps:
                self.subjectmaps[subjectclass] = [subject]
            else:
                #self.subjectmaps[subjectclass].append(subject)
                for sub in self.subjectmaps[subjectclass]:
                    if sub.id == str(row.s):
                        sub.predicates.append(pred)

        return self.subjectmaps[subjectclass]


if __name__ == "__main__":
    mapping = RMLMapping("../../csvmapping.ttl").getMapping("http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/Product")
    #mapping.loadAllMappings()
    print str(mapping)