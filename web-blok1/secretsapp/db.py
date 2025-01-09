#Deze code zorgt voor de verbinding met de database
from flask import g as app_context_global
import mysql.connector


def db_connection():
    """This function can be called to access the database connection while handling a request"""
    if 'db' not in app_context_global:
        # TODO: store config in config file
        # TODO: do not store secrets on git

        app_context_global.db = mysql.connector.connect(
            host="192.168.1.20",
            port="3306",
            database="secrets",
            user="secrets",
            password="BestPassword"
        )
    return app_context_global.db

def teardown_db(exception):
    db = app_context_global.pop('db', None)

    if db is not None:
        db.close()
