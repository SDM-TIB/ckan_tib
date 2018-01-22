from ontario.common.parser.services import *


def decomposeQuery(query):
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


def vartocolumnmapping(mapping, triplepatterns):
    varmap = dict()

    subj = mapping.subjecttemplate[mapping.subjecttemplate.find('{') + 1: mapping.subjecttemplate.find('}')]

    predicates = mapping.predicates
    predmap = [(p.predicate, p.refmap) for p in predicates]

    for t in triplepatterns:
        if subj not in varmap and not t.subject.constant:
            varmap[t.subject.name] = str(subj)

        if t.predicate.constant:
            pp = [p[1].name for p in predmap if p[0] == t.predicate.name]
            if len(pp) > 0:
                varmap[t.theobject.name] = pp[0]

    return varmap


def getFROMClause(subjectColumn, maxnumofobj):
    if maxnumofobj > 1:
        tables = [subjectColumn + " table" + str(i) for i in range(1, maxnumofobj + 1)]
        fromcaluse = " FROM " + ", ".join(tables)
    else:
        fromcaluse = " FROM " + subjectColumn
    return fromcaluse + " "


def getProjectionClause(variablemap, sparqlprojected, maxnumofobj):

    firstprojection = True
    projections = " SELECT "
    for var in sparqlprojected:
        if var in variablemap:
            column = variablemap[var]
            if not firstprojection:
                projections += ","

            if maxnumofobj > 1:
                projections += " table" + str(maxnumofobj) + "." + column + " AS " + var[1:]
            else:
                projections += " " + column + " AS " + var[1:]

            firstprojection = False
        #else:
        #    print sparqlprojected, var

    projections += " "

    return projections


def getSubjectFilters(ifilters, maxnumofobj):
    subjectfilters = ""
    firstfilter = True
    if len(ifilters) > 0:
        if maxnumofobj == 0:
            if not firstfilter:
                subjectfilters += ' AND '

            subjectfilters += ifilters[0][0] + " = " + ' "' + ifilters[0][2] + '" '
            firstfilter = False

        else:
            for i in range(1, maxnumofobj + 1):
                if not firstfilter:
                    subjectfilters += ' AND '

                subjectfilters += "table" + str(i) + "." + ifilters[0][0] + " = " + ' "' + ifilters[0][2] + '" '
                firstfilter = False

    else:
        return None, firstfilter

    return subjectfilters, firstfilter


def getPredObjDict(triplepatterns, varmap):
    predobjdict = {}
    needselfjoin = False
    maxnumofobj = 0
    for t in triplepatterns:
        if t.predicate.constant:
            if t.predicate.name[1:-1] in predobjdict:
                needselfjoin = True
                val = predobjdict[t.predicate.name[1:-1]]
                if type(val) == list:
                    predobjdict[t.predicate.name[1:-1]].append(t)
                else:
                    predobjdict[t.predicate.name[1:-1]] = [val, t]
                if len(predobjdict[t.predicate.name[1:-1]]) > maxnumofobj:
                    maxnumofobj = len(predobjdict[t.predicate.name[1:-1]])
            else:
                predobjdict[t.predicate.name[1:-1]] = t

    return predobjdict, needselfjoin, maxnumofobj


def getObjectFilters(mapping, triplepatterns, subjectVar, maxnumofobj, firstfilter, sparqlprojected):

    objectfilters = ""
    filtersmap = {}
    nans = []
    filters = [(t.predicate.name[1:-1], " = ", t.theobject.name[1:-1])
               for t in triplepatterns if t.predicate.constant and t.theobject.constant]

    predvars = [(t.predicate.name[1:-1], " = ", t.theobject.name)
                for t in triplepatterns if t.predicate.constant and not t.theobject.constant]

    if len(filters) == 0 and len(predvars) == 0:
        return None

    predmap = {t.predicate[1:-1]: t.refmap.name for t in mapping.predicates}
    for v in predvars:
        if v[0] not in predmap:
            continue

        if v[2] not in sparqlprojected:
            nans.append(v[0])

    for f in filters:
        if f[0] not in predmap:
            continue
        if f[0] in filtersmap:
            filtersmap[f[0]].append(f[2])
        else:
            filtersmap[f[0]] = [f[2]]

    for v in filtersmap:
        for idx, val in zip(range(1, len(filtersmap[v])+1), filtersmap[v]):
            if not firstfilter:
                objectfilters += ' AND '
            if maxnumofobj > 1:
                objectfilters += " table" + str(idx) + "." + predmap[v] + " = " + ' "' + val + '" '
            else:
                objectfilters += predmap[v] + " = " + ' "' + val + '" '

            firstfilter = False

    for v in set(nans):
        if not firstfilter:
            objectfilters += ' AND '

        if maxnumofobj > 1:
            objectfilters += " table" + str(maxnumofobj) + "." + predmap[v] + " is not null "

        else:
            objectfilters += ' ' + predmap[v] + " is not null "

        firstfilter = False

    joinvars = ""
    firstjoin = True
    if len(filters) > 0:
        for i in range(1, maxnumofobj+1):
            if maxnumofobj > 1 and i-1 > 0:
                if not firstjoin:
                    joinvars += " AND "

                joinvars += "table" + str(i-1) + "." + subjectVar + " = " + "table" + str(i) + "." + subjectVar
                firstjoin = False

        if not firstfilter and maxnumofobj > 1:
            objectfilters += " AND " + joinvars
        else:
            objectfilters += " " + joinvars + " "

    return objectfilters, firstfilter


def getSparqlFilters(filters, mapping, maxnumofobj, firstfilter, varmap):
    op = filters.expr.op
    left = filters.expr.left
    right = filters.expr.right
    simplefilters = ""
    predmap = {t.predicate[1:-1]: t.refmap.name for t in mapping.predicates}
    numoperators = ['<', '>', '>=', '<=']
    if isinstance(left, Argument) and isinstance(right, Argument):
        if not left.constant and right.constant:
            if not firstfilter:
                simplefilters += ' AND '

            if "<" in right.name and ">" in right.name:
                val = right.name[1:-1]

            else:
                val = right.name

            if maxnumofobj > 1:
                simplefilters += " table" + str(maxnumofobj) + "." + varmap[left.name] + ' ' + str(op) + (' ' if str(op) in numoperators else ' "') + val + ('' if str(op) in numoperators else '" ')

            else:
                simplefilters += varmap[left.name] + ' ' + str(op) + (' ' if str(op) in numoperators else ' "')+ val + ('' if str(op) in numoperators else '" ')
        elif left.constant and not right.constant:
            if not firstfilter:
                simplefilters += ' AND '

            if "<" in left.name and ">" in left.name:
                val = left.name[1:-1]

            else:
                val = left.name

            if maxnumofobj > 1:
                simplefilters += " table" + str(maxnumofobj) + "." + varmap[right.name] + ' ' + str(op) + (' ' if str(op) in numoperators else ' "') + val + ('' if str(op) in numoperators else '" ')

            else:
                simplefilters += varmap[right.name] + ' ' + str(op) + ( ' ' if str(op) in numoperators else ' "') + val + ('' if str(op) in numoperators else '" ')
    else:
        return None

    return simplefilters
