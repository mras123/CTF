import hashlib
from flask import Blueprint, request, render_template, redirect, session, flash, url_for, render_template_string
from flask_login import current_user, logout_user, login_user, UserMixin
from .db import db_connection

class User(UserMixin):
    def __init__(self, username, voornaam, email, last_login):
        self.username = username
        self.voornaam = voornaam
        self.email = email
        self.last_login = last_login

    def get_id(self):
        return self.username

class HomePage(Blueprint):
    def __init__(self, name, import_name):
        super().__init__(name, import_name)
        self.route("/", methods=["GET"])(self.index_get)
        self.route("/about")(self.about_us)
        self.route("/login", methods=["POST"])(self.login_post)
        self.route("/logout")(self.logout)
        self.route("/level2")(self.leveltwo)
        self.route("/level3")(self.levelthree)
        self.route("/hint")(self.hint)
        self.route("/search", methods=["GET"])(self.search)
        self.route('/flag', methods=['POST'])(self.capture_flag)  # Define route for capturing flag here

    def index_get(self):
        logged_in = current_user.is_authenticated
        return render_template("home/index.html", logged_in=logged_in)

    def about_us(self):
        logged_in = current_user.is_authenticated
        return render_template("home/about.html", logged_in=logged_in)

    def login_post(self):
        username = request.form.get("username")
        password = request.form.get("password")
        db = db_connection()
        cursor = db.cursor()
        error = None
        errors = []

        if not username or not password:
            error = "Vul alle velden in."
            errors.append(error)
        else:
            query = f"SELECT username, password FROM Users WHERE username='{username}' AND password='{password}'"
            cursor.execute(query)
            user = cursor.fetchone()
            if user:
                return render_template("home/level2.html")
            else:
                msg = "Login unsuccessful. Username or Password incorrect."
        return render_template("home/about.html", msg=msg)

    def logout(self):
        if current_user.is_authenticated:
            logout_user()
            flash("You have been logged out", "info")
        return redirect("/")

    def leveltwo(self):
        logged_in = current_user.is_authenticated
        return render_template("home/level2.html", logged_in=logged_in)

    def levelthree(self):
        logged_in = current_user.is_authenticated
        return render_template("home/level3.html", logged_in=logged_in)

    def hint(self):
        flash("Hint: To capture the flag, try using SQL injection techniques in the login form with a common username and password.", "hint")
        return redirect(url_for("home.about_us"))

    def search(self):
        username = request.args.get('username')
        sql_injection_patterns = ["' OR '1'='1", "' OR 1=1", "' OR 'a'='a", "' OR ''='", "--", "'; --", "'; DROP"]
        
        if username:
            db = db_connection()
            cursor = db.cursor()

            if any(pattern in username for pattern in sql_injection_patterns):
                query = f"SELECT * FROM Users WHERE username = '{username}' OR 1=1"
            else:
                query = f"SELECT * FROM Users WHERE username = '{username}'"

            cursor.execute(query)
            columns = [col[0] for col in cursor.description]
            users = [dict(zip(columns, row)) for row in cursor.fetchall()]
            db.close()

            if users:
                return render_template_string('''
                    <h1>User Information</h1>
                    {% for user in users %}
                    <p>Username: {{ user['username'] }}</p>
                    <p>Password: {{ user['password'] }}</p>
                    <form action="/flag" method="post">
                        <input type="hidden" name="flag" value="captured">
                        <button type="submit">Capture Flag</button>
                    </form>                        
                    <hr>
                    {% endfor %}
                ''', users=users)
            else:
                return '<h1>No user found with that username.</h1>'
        return '<h1>Please enter a username to search.</h1>'

    # Define capture_flag method here
    def capture_flag(self):
        if request.method == 'POST':
            if request.form.get('flag') == 'captured':
                # HTML message with an image of a flag
                return '''
                    <h1>Flag has been captured!</h1>
                    <p>Congratulations! You successfully captured the flag.</p>
                    <style>
                        .flag-image {
                            width: 100px; /* Adjust this value to make the image smaller */
                            height: auto; /* Maintains aspect ratio */
                            
                        }
                    </style>
                    <img src="/static/css/imgs/red-flag.png" alt="Flag" class="flag-image">
                '''
            else:
                # Return a message if the flag capture failed
                return 'Flag capture failed!'
        else:
            # Return a message if the method is not allowed
            return 'Method not allowed'

bp = HomePage("home", __name__)
