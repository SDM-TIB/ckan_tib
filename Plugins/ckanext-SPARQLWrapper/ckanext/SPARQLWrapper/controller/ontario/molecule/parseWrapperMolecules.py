__author__ = 'kemele'

import json
from ontario.molecule.molecule import Molecule, TripleTemplate, NodeType, Resource


def parse(moleculesFile, tripleTemplatesFile):
    '''
    Parse molecule and triple templates metadata from JSON file
    :param moleculesFile: molecules metadata in JSON format
    :param tripleTemplatesFile: triple templates metadata in JSON format
    :return: tuple(moleculeDict(moleculeId, Molecule), prefixes(pref, uri))
    '''
    with open(moleculesFile) as mfile:
        moleculesJson = json.load(mfile)
    with open(tripleTemplatesFile) as tfile:
        templatesJson = json.load(tfile)

    templates, prefs = getTemplates(templatesJson)

    molecules = dict()
    prefixes = moleculesJson['prefixes']
    ms = moleculesJson['molecules']
    for p in prefixes:
        prefs[p] = prefixes[p]
    for m in ms:
        molecule = m['molecule']
        pp = prefix(molecule)
        if pp and prefs[pp[0]]:
            molecule = prefs[pp[0]] + pp[1]
        molecules[molecule] = dict()
        wrappers = m['wrappers']

        for w in wrappers:
            mol = getMolecule(w, templates, prefs)
            molecules[molecule][mol.mid] = mol
    for m in molecules.copy():
        for w in molecules[m]:
            if molecules[m][w].linkedTo:
                links = []
                for l in molecules[m][w].linkedTo:
                    if l in molecules[m] and l != m:
                        links.append(molecules[m][l])
                molecules[m][w].linkedTo = links

    return molecules, templates, prefs


def getTemplates(templatesJson):
    '''
    Parse triple templates JSON file
    :param templatesJson: triple templates JSON file
    :return: tuple(templateDict(template-id, TripleTemplate), prefixesDict(pref, url))
    '''
    prefixes = templatesJson['prefixes']
    ms = templatesJson['templates']
    prefs = dict()
    templates = dict()
    for p in prefixes:
        prefs[p] = prefixes[p]
    for t in ms:
        tid = t['ID']
        subjType = t['subjType']
        pp = prefix(subjType)
        if pp and prefs[pp[0]]:
            subjType = prefs[pp[0]] + pp[1]
        pred = t['pred']
        pp = prefix(pred)
        if pp and prefs[pp[0]]:
            pred = prefs[pp[0]] + pp[1]
        objType = t['objType']
        pp = prefix(objType)
        if pp and prefs[pp[0]]:
            objType = prefs[pp[0]] + pp[1]
        count = t['count']
        if not count:
            count = -1
        else:
            try:
                c = int(count)
            except:
                c = -1
            count = c
        temp = TripleTemplate(tid, subjType, pred, objType, count)
        templates[tid] = temp
    return templates, prefs


def getMolecule(mm, templates, prefs):
    '''
    Parse a molecule JSON object and find equivalent triple templates in triple template dictionary
    :param m: molecule JSON object
    :param templates: dictionary of triple templates {template-id: TripleTemplate}
    :param prefs: dictionary of prefixes
    :return: Molecule
    '''

    mid = mm["ID"]
    rootType = mm["rootType"]
    pp = prefix(rootType)
    if pp and prefs[pp[0]]:
        rootType = prefs[pp[0]] + pp[1]
    metaWrapper = mm['wrapper']
    urlparams = mm['urlparams']
    metaWrapper += "?"+urlparams
    mtemplates = mm['templates']
    mtemplates = getMTemplates(mtemplates, templates)
    linkedTo = mm['linkedTo']
    count = mm['count']
    if not count:
        count = -1
    else:
        try:
            c = int(count)
        except:
            c = -1
        count = c
    mol = Molecule(mid, rootType, metaWrapper, urlparams, prefs, mtemplates, linkedTo, count)
    return mol

def getMTemplates(mtemp, templates):
    '''
    Extract list of TripleTemplates of molecule template (mtemp[]) from templates dictionary
    :param mtemp: list of templates in a molecule
    :param templates: array of TripleTemplates
    :return:
    '''
    temps = []
    for t in mtemp:
        if t in templates:
            temps.append(templates[t])
    return temps

def prefix(s):
    '''
    Split resource representation to prefix and uri
    :param s: resource
    :return: tuple(pref, uri)
    '''
    pos = s.find(":")
    if (not (s[0] == "<")) and pos > -1:
        return (s[0:pos].strip(), s[(pos+1):].strip())

    return None


def getPrefs(ps):

    prefDict = dict()
    for p in ps:
         pos = p.find(":")
         c = p[0:pos].strip()
         v = p[(pos+1):len(p)].strip()
         prefDict[c] = v
    return prefDict


def getUri(p, prefs):
    hasPrefix = prefix(p)
    if hasPrefix:
        (pr, su) = hasPrefix
        n = prefs[pr]
        n = n[:-1]+su+">"
        return n
    return p.name

