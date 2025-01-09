# __init__.py

from flask import Flask
from flask_login import LoginManager
from secretsapp.db import db_connection, teardown_db
from secretsapp.home import bp as home_bp
from secretsapp.home import User

login_manager = LoginManager()

def create_app() -> Flask:
    app = Flask(__name__)
    app.config["SECRET_KEY"] = "your_secret_key_here"
    app.config['MAIL_SERVER'] = 'smtp.gmail.com'
    app.config['MAIL_PORT'] = 465
    app.config['MAIL_USERNAME'] = 'SecretManager.nl@gmail.com'
    app.config['MAIL_PASSWORD'] = 'your_mail_password_here'
    app.config['MAIL_USE_TLS'] = False
    app.config['MAIL_USE_SSL'] = True

    # Register blueprints
    app.register_blueprint(home_bp)

    # Initialize Flask-Login
    login_manager.init_app(app)
    login_manager.login_view = 'home.login'  # Specify the login view

    # Teardown database
    app.teardown_appcontext(teardown_db)

    return app

@login_manager.user_loader
def load_user(username):
    database = db_connection()
    cursor = database.cursor()
    query = "SELECT username, voornaam, email, last_login FROM users WHERE username = %(username)s"
    data = {'username' : username}
    cursor.execute(query, data)
    result = cursor.fetchone()
    if result:
        username, voornaam, email, last_login = result
        return User(username, voornaam, email, last_login)
    else:
        return None  # Return None if user not found
