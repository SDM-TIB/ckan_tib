from multiprocessing import Queue
from ontario.common.parser.services import Expression, Argument
import datetime
import operator


class UnaryOp(object):

    def __init__(self, op, left):
        self.op = op
        self.left = left
    def __repr__(self):
        return self.op, self.left

class BinaryOp(object):

    def __init__(self, op, left, right):
        self.op = op
        self.right = right
        self.left = left

    def __repr__(self):

        return "binaryopreator:" + str(self.op) + str(self.left) + str(self.right)


class FilterHelper(object):

    def __init__(self, filters):
        self.filters = filters

    def evaluate(self, op=None, left=None, right=None, res=[]):
        if not op and not left and not right:
            op = self.filters.expr.op
            left = self.filters.expr.left
            right = self.filters.expr.right
        if isinstance(left, Expression) and isinstance(right, Expression):
            print "Case I, OP(Expr, Expr)"
            self.evaluate(left.op, left.left, left.right, res)
            self.evaluate(right.op, right.left, right.right, res)
            #res = self.evaluate(op, resleft, resright)
            res.append(op)
        elif isinstance(left, Argument) and isinstance(right, Argument):
            print "Case V"
            res.append(BinaryOp(op, left, right))
        elif isinstance(left, Argument) and isinstance(right, None):
            print "Case IV"
            res.append(UnaryOp(op, left))
        else:
            pass
        '''
        elif isinstance(left, Expression) and isinstance(right, Argument):
            print "Case II"
            self.evaluate(left.op, left.left, left.right, res)
            res = self.evaluate(op, resleft, right)
        elif isinstance(left, Argument) and isinstance(right, Expression):
            print "Case III"
            resright = self.evaluate(right.op, right.left, right.right)
            res = self.evaluate(op, left, resright)
        elif isinstance(left, Expression) and isinstance(right, None):
            print "Case IV"
            resleft = self.evaluate(left.op, left.left, left.right)
            res = self.evaluate(op, resleft, right)
        '''

    def extractValue(self, val):
        pos = val.find("^^")
        # Handles when the literal is typed.
        if (pos > -1):
            for t in data_types.keys():
                if (t in val[pos:]):
                    (python_type, general_type) = data_types[t]
                    if (general_type == bool):
                        return (val[:pos], general_type)
                    else:
                        return (python_type(val[:pos]), general_type)
        else:
            return (str(val), str)

unary_operators = {
        '!'  : operator.not_,
        '+'  : '',
        '-'  : operator.neg,
        'bound' : lambda a: len(a) > 0
        }

logical_connectives = {
        '||' : operator.or_,
        '&&' : operator.and_
        }

arithmetic_operators = {
        '*'  : operator.mul,
        '/'  : operator.div,
        '+'  : operator.add,
        '-'  : operator.sub,
         }

test_operators = {
        '='  : operator.eq,
        '!=' : operator.ne,
        '<'  : operator.lt,
        '>'  : operator.gt,
        '<=' : operator.le,
        '>=' : operator.ge
        }

data_types = {
        'integer' : (int, 'numerical'),
        'decimal' : (float, 'numerical'),
        'float'   : (float, 'numerical'),
        'double'  : (float, 'numerical'),
        'string'  : (str, str),
        'boolean' : (bool, bool),
        'dateTime' : (datetime, datetime),
        'nonPositiveInteger' : (int, 'numerical'),
        'negativeInteger' : (int, 'numerical'),
        'long'    : (long, 'numerical'),
        'int'     : (int, 'numerical'),
        'short'   : (int, 'numerical'),
        'byte'    : (bytes, bytes),
        'nonNegativeInteger' : (int, 'numerical'),
        'unsignedLong' : (long, 'numerical'),
        'unsignedInt'  : (int, 'numerical'),
        'unsignedShort' : (int, 'numerical'),
        'unsignedByte' : (bytes, bytes), # TODO: this is not correct
        'positiveInteger' : (int, 'numerical')
        }

numerical = (int, long, float)


if __name__ == "__main__":
    csvjsonquery = """
                    PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
                    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                    select ?offer ?webpage
                    where {
                        ?offer bsbm:validFrom ?webpage .
                        ?offer bsbm:product <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/dataFromProducer2304/Product116132> .
                        FILTER ((?offer=<http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/dataFromVendor55/Offer116064>) || (?offer=<http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/dataFromVendor117/Offer232819>) || (?offer=<http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/dataFromVendor373/Offer731787>))
                    }
        """
    from ontario.common.parser import queryParser as qp
    from ontario.common.parser.services import *
    query = qp.parse(csvjsonquery)
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

    if len(filters) > 0:
        helper = FilterHelper(filters[0])
        res = []
        helper.evaluate(res=res)
        stack = []
        while len(res) > 0:
            p = res.pop()
            if isinstance(p, str):
                stack.append(p)
            print p