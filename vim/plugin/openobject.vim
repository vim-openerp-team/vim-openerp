" Configuration file for OpenObject Editor

let g:OObj_AUTOLOAD="no"
let g:OObj_HOST="localhost"
let g:OObj_DB="demo"
let g:OObj_USER="admin"
let g:OObj_PASS="admin"
let g:OObj_PORT=8069

" Python functions

python << EOL
from pprint import pprint
try:
    from oobjlib.connection import Connection
    from oobjlib.component import Object
except Exception:
    Connection = None
    Object = None

def oerpConnect(server=None, dbname=None, login=None, password=None, port=None):
    """
    Creates a connection to OpenERP using Openobject Library and get the user's context
    """

    # Connection parameters
    if server is None:
        server = vim.eval('g:OObj_HOST')
    if dbname is None:
        dbname = vim.eval('g:OObj_DB')
    if login is None:
        login = vim.eval('g:OObj_USER')
    if password is None:
        password = vim.eval('g:OObj_PASS')
    if port is None:
        port = vim.eval('g:OObj_PORT')

    # Open the connection
    connection =  Connection(
        server=server,
        dbname=dbname,
        login=login,
        password=password,
        port=port,
    )
    # Get the user context
    context = Object(connection, 'res.users').context_get()

    return (connection, context)

def oerpDisplayResult(text):
    """
    Add the contents of 'text' in the current vim buffer
    """
    line = vim.current.window.cursor[0]
    for content in text.split('\n'):
        vim.current.buffer.append(content.encode('utf8', 'replace'), line)
        line += 1

def oerpCallMethod(methodName, model, *args):
    """
    Call any method of an object
    """
    (connection, globalContext) = oerpConnect()
    obj = Object(connection, model)
    pprint(getattr(obj, methodName)(*args))

def oerpRead(model, model_id, fields=None, context=None):
    """
    Call the read method and prints the result
    """
    (connection, globalContext) = oerpConnect()
    obj = Object(connection, model)
    if context is None:
        context = globalContext

    pprint(obj.read(model_id, fields, context))

def oerpGetFields(model, fields=None, context=None):
    """
    Perform a fields_get and print the result
    """
    (connection, globalContext) = oerpConnect()
    obj = Object(connection, model)
    if context is None:
        context = globalContext

    pprint(obj.fields_get(fields, context))

def oerpGetView(model, view_id=None, view_type=None, context=None):
    """
    Perform a fields_view_get and print the result in the current buffer
    """
    (connection, globalContext) = oerpConnect()
    obj = Object(connection, model)
    if context is None:
        context = globalContext

    oerpDisplayResult(obj.fields_view_get(view_id, view_type, context)['arch'])

EOL
