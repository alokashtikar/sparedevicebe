import decimal
import json
import enum


class DecimalEncoder(json.JSONEncoder):
    """
    This was copied from AWS
    Helper class to convert a DynamoDB item to JSON.
    """

    def default(self, o):
        if isinstance(o, decimal.Decimal):
            sign = 1
            if o < 0:
                sign = -1
            o = abs(o)
            if o % 1 > 0:
                return sign * float(o)
            else:
                return sign * int(o)
        return super(DecimalEncoder, self).default(o)


def convert_to_dynamo_compatible(body: dict):
    return erase_empty(json.loads(body, parse_float=decimal.Decimal))


set_appender = lambda i, r: r.add(i)

list_appender = lambda i, r: r.append(i)

type_dispatch = {
    type(set()) : lambda c, r: filter_non_empty(set_appender, c, r),
    type(list()) : lambda c, r: filter_non_empty(list_appender, c, r),
    type(dict()) : lambda c, r: filter_non_empty_from_dict(c, r),
    type(str()) : lambda c, r: non_empty(c),
    type(True) : lambda c, r: c
}


def non_empty(c):
    if len(c):
        return c
    return None


def filter_non_empty(appender, container, result):
    for x in container:
        i = erase_empty(x)
        if i is not None:
            appender(i, result)
    return non_empty(result)


def filter_non_empty_from_dict(container_dict, result):
    for k, v in container_dict.items():
        non_empty_key = erase_empty(k)
        non_empty_value = erase_empty(v)
        # the check for is not None below is important, it covers for booleans as type for k or v
        if non_empty_key is not None and non_empty_value is not None:
            result[non_empty_key] = non_empty_value
    return non_empty(result)


def erase_empty(c):
    c_type = type(c)
    if c_type not in type_dispatch.keys():
        return c
    return type_dispatch[c_type](c, c_type())


def required(req_data: dict, fields: set):
    if set(req_data.keys()).intersection(fields) != fields:
        raise ValueError("missing one or more of required fields: {}".format(fields))


def require_valid_enum(enumerated_value, the_enum: enum.Enum):
    s = set()
    for e in the_enum:
        s.add(e.name)
    require_one_of(enumerated_value, s)


def require_one_of(value, valid_values):
    if value not in valid_values:
        raise ValueError("value [{}] must be one of [{}]".format(value, valid_values))


def get_bool(f: str):
    if f.lower() in {'true', 'yes', '1'}:
        return True
    if f.lower() in {'false', 'no', '0'}:
        return False
    raise ValueError("incorrect value for Boolean: {}", f)


def get_user_id_from_gateway_event(event):
    return event['requestContext']['authorizer']['claims']['sub']


def get_username_from_gateway_event(event):
    return get_email_from_gateway_event(event)


def get_email_from_gateway_event(event):
    return event['requestContext']['authorizer']['claims']['email']


def require_valid_values(template, data):
    """
    Validate values against template,note that all keys in template should be in data's keys as well
    Note that this only works for numeric expressions

    Args:
        template: A dictionary of <key, value> pairs where keys are field name and value list of
        expressions that the key must satisfy
        condition that it has to satisfy, for e.g.,
        - {'numberOfShares': ['>= 0'], 'purchasePrice': ['> 0'],...}
        - note that to check if a field is not string, simply set the expression

        data: A dictionary of <key, value> pairs, where the key is a field name and the value if
        the value of the field that will be validated against the template.


    Return:
        Raise an error if the data does not meet the template's spec
        True Otherwise
    """
    keys = [x for x in data.keys() if x in template.keys()]
    for key in keys:
        for elt in template[key]:
            data[key] = float(data[key])
            expr = "data[key] {}".format(elt)
            if eval(expr) is not True:
                raise ValueError("incorrect value for field {} ".format(key))
    return True


def overlap(s1: int, e1: int, s2: int, e2: int):
    return not (e1 <= s2 or e2 <= s1)
