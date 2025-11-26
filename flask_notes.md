`Flask-Migrate: Database not upto date`:
---------------------------------------------
To set the revision in the database to the head, without performing any migrations. You can change head to the required change you want.

    flask db stamp head 


To detect automatically all the changes.

    flask db migrate     

    
To apply all the changes.
    
    flask db upgrade    



`Get/pass data from UI  - Flask request`
---------------------------------------------
    request.args        :       the key/value pairs in the URL query string
    request.form        :       the key/value pairs in the body, from a HTML post form, or JavaScript request that isn't JSON encoded
    request.files       :       the files in the body, which Flask keeps separate from form. HTML forms must use enctype=multipart/form-data or files will not be uploaded.
    request.values      :       combined args and form, preferring args if keys overlap
    request.json        :       parsed JSON data. The request must have the application/json content type, or use request.get_json(force=True) to ignore the content type.

For URL query parameters, use request.args:

    search = request.args.get("search")

For posted form input, use request.form:

    email = request.form.get('email')

For JSON posted with content type application/json, use request.get_json().

    data = request.get_json()


`PYTHON to JS`
---------------------------------------------
    JSON.parse('{{ <data_from_python> | tojson }}');


---------------------------------------------
Get PATH of a directory in Python

    import os
    os.getcwd()


`PYTHON - List Comprehension (one line loop)`
---------------------------------------------
https://www.w3schools.com/python/python_lists_comprehension.asp

syntax  :   
    
    newlist = [ <expression> for <item> in <iterable> ]

w/ condition
syntax  :   
    
    newlist = [ <expression> for <item> in <iterable> if <condition> == True ]


`Using environment variables`  
---------------------------------------------
(reads key-value pairs from a .env file and can set them as environment variables)
    
    pip install python-dotenv

folder structure:

    .
    ├── .env
    └── foo.py


    .env syntax:
    key = value


in python file:

    from dotenv import load_dotenv
    load_dotenv()                   # take environment variables
    env_var = os.getenv("key")      # access the variable's value


<!-- --------------------------------------------- -->
<!-- --------------------------------------------- -->


## `Flask: ajax datatables not working`

when url links have '  url: /link/value?_=000000000000  '  
this is due to ajax cache, set cache to false

	cache: false

https://datatables.net/forums/discussion/45935/jquery-ajax-in-flask-not-working



<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ -->
## `FLASK: creating database in app context`
https://flask-sqlalchemy.palletsprojects.com/en/2.x/contexts/

Some functions inside Flask-SQLAlchemy also accept optionally the application to operate on:

	from yourapp import db, create_app
	db.create_all(app=create_app())


    