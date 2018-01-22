__author__ = 'kemele'


class Molecule(object):
    def __init__(self, mid, rootType, metaWrapper, prefixes={},templates=[], linkedTo=[], count=-1, findLinks = False, urlparams=""):
        self.mid = mid
        self.rootType = rootType
        self.metaWrapper = metaWrapper
        self.templates = templates
        self.linkedTo = linkedTo
        self.count = count
        self.findLinks = findLinks
        self.prefixes = prefixes
        self.urlparams = urlparams

    def __repr__(self):
        rep = '\n'+ str(self.prefixes) +"\n\n"
        rep += "ID: " + self.mid + "\nRoot: " + self.rootType + "\nMeta-Wrapper: " \
              + self.metaWrapper + "?" + self.urlparams + "\nCount: " + str(self.count) + "\nTemplates: \n"
        for t in self.templates:
            rep += str(t)
        return rep


class TripleTemplate(object):
    def __init__(self, tid, subjType, pred, objType, prefixes=[], count=-1, isGeneric = False):
        self.tid = tid
        self.subjType = subjType
        self.pred = pred
        self.objType = objType
        self.count = count
        self.isGeneric = isGeneric
        self.prefixes = prefixes

    def __repr__(self):
        rep = "\t\t" + self.tid +" =>     [" + self.subjType + "] [" + self.pred + "] [" + self.objType + "]    => Count: " + str(self.count) +'\n'
        return rep


class NodeType(object):
    def __init__(self):
        self.ANY = "ANY"
        self.LITERAL = "Literal"
        self.URI = "URI"
        self.BLANK_NODE = "BLANK"


class Resource(object):
    def __init__(self, name, pref="", uri=""):
        self.name = name
        self.pref = pref
        self.uri = uri
