import json
import abc


class Config(object):
    def __init__(self, configfile):
        self.configfile = configfile
        self.mappingFolder = "/home/Ontario/mappings"
        self.wrappers = self.getWrappers()
        self.metadata = self.getAllMolecules()
        self.predidx = self.createPredicateIndex()



    @abc.abstractmethod
    def getAllMolecules(self):
        return None

    @abc.abstractmethod
    def getWrappers(self):
        return None

    def createPredicateIndex(self):
        pidx = {}
        for m in self.metadata:
            preds = self.metadata[m]['predicates']
            for p in preds:
                if p['predicate'] not in pidx:
                    pidx[p['predicate']] = set()
                    pidx[p['predicate']].add(m)
                else:
                    pidx[p['predicate']].add(m)

        return pidx

    def findbypreds(self, preds):
        res = []
        for p in preds:
            if p in self.predidx:
                res.append(self.predidx[p])
        for r in res[1:]:
            res[0] = res[0].intersection(r)

        mols = list(res[0])

        # for m in self.metadata:
        #     found = True
        #     for p in preds:
        #         mps = [pm['predicate'] for pm in self.metadata[m]['predicates']]
        #         if p not in mps:
        #             found = False
        #             break
        #     if found:
        #         mols.append(m)

        return mols

    def findbypred(self, pred):
        res = []
        if pred in self.predidx:
            res.append(self.predidx[pred])
        for r in res[1:]:
            res[0] = res[0].union(r)

        mols = list(res[0])

        # for m in self.metadata:
        #     mps = [pm['predicate'] for pm in self.metadata[m]['predicates']]
        #     if pred in mps:
        #         mols.append(m)
        #
        return mols

    def findMolecule(self, molecule):
        if molecule in self.metadata:
            return self.metadata[molecule]
        else:
            return None


class ConfigFile(Config):

    def getAllMolecules(self):
        return self.readJsonFile(self.configfile)

    def getWrappers(self):
        with open(self.configfile) as f:
            conf = json.load(f)
        wrappers = {}
        if "WrappersConfig" in conf:
            if "MappingFolder" in conf['WrappersConfig']:
                self.mappingFolder = conf['WrappersConfig']['MappingFolder']

            for w in conf['WrappersConfig']:
                wrappers[w] = conf['WrappersConfig'][w]

        return wrappers

    def readJsonFile(self, configfile):
        with open(configfile) as f:
            conf = json.load(f)

        if 'MoleculeTemplates' not in conf:
            return None
        moleculetemps = conf['MoleculeTemplates']
        meta = {}
        for mt in moleculetemps:
            if mt['type'] == 'filepath':
                with open(mt['path']) as f:
                    mts = json.load(f)

                for m in mts:
                    if m['rootType'] in meta:
                        # linkedTo
                        links = meta[m['rootType']]['linkedTo']
                        links.extend(m['linkedTo'])
                        meta[m['rootType']]['linkedTo'] = list(set(links))

                        # predicates
                        preds = meta[m['rootType']]['predicates']
                        mpreds = m['predicates']
                        ps = {p['predicate']: p for p in preds}
                        for p in mpreds:
                            if p['predicate'] in ps and len(p['range']) > 0:
                                ps[p['predicate']]['range'].extend(p['range'])
                                ps[p['predicate']]['range'] = list(set(ps[p['predicate']]['range']))
                            else:
                                ps[p['predicate']] = p

                        meta[m['rootType']]['predicates'] = []
                        for p in ps:
                            meta[m['rootType']]['predicates'].append(ps[p])

                        # wrappers
                        wraps = meta[m['rootType']]['wrappers']
                        wrs = {w['url']+w['wrapperType']: w for w in wraps}
                        mwraps = m['wrappers']
                        for w in mwraps:
                            key = w['url'] + w['wrapperType']
                            if key in wrs:
                                wrs[key]['predicates'].extend(wrs['predicates'])
                                wrs[key]['predicates'] = list(set(wrs[key]['predicates']))

                        meta[m['rootType']]['wrappers'] = []
                        for w in wrs:
                            meta[m['rootType']]['wrappers'].append(wrs[w])
                    else:
                        meta[m['rootType']] = m
        f.close()
        return meta
