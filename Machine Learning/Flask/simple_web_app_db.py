# "SQLAlchemy" allows creating a database
# "render_template" allows displaing html website decorated with @app
# "redirect" allows redirect dor a specific URL
# "url_for" allows for providing a specific URL for "redirect"
# "request" 
# "session" allows to create a session keeping some data
# "flash" allows displaying messages

from flask import Flask, redirect, url_for, render_template, request, session, flash
from datetime import timedelta
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)
app.secret_key = "databusters" # needed for decrypting the data send to/from database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.sqlite3' # database config
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.permanent_session_lifetime = timedelta(minutes=5) # time period for session lifetime

db = SQLAlchemy(app) # database creation

# class creating a database
class users(db.Model):
    _id = db.Column("id", db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100))

    def __init__(self, name, email):
        self.name = name
        self.email = email

# Defining the home page of our site
@app.route("/")
def home():
    return render_template("index.html")

# Redirecting user to specific website "home"
@app.route("/admin")
def admin():
	return redirect(url_for("home"))

# Redirecting user to specific website "About"
@app.route("/about")
def about():
	return render_template("about.html")    

# Redirecting user to specific website "Login"
@app.route("/login", methods=["POST", "GET"]) # on this website POST and GET methods are used
def login():
    if request.method == "POST": # POST used for keeping the user data from a form
        session.permanent = True  # <--- makes the permanent session
        looser = request.form["nm"] # remembers "name" as looser
        session["looser"] = looser # session is a dictionary loosr key = looser value
        flash("Login Successful!")
        return redirect(url_for("user"))
    else:
        if "looser" in session:
            flash("Already logged in!")
            return redirect(url_for("user"))

        return render_template("login.html")

@app.route("/user", methods=["POST", "GET"])
def user():
    email = None
    if "looser" in session:
        looser = session["looser"]
        if request.method == "POST":
            email = request.form["email"]
            session["email"] = email
            flash("Email was saved!")
        else:
            if email in session:
                email = session["email"]

        return render_template("user.html", email = email, looser = looser)
    else:
        flash("You are not logged in!")
        return redirect(url_for("login"))

@app.route("/logout")
def logout():
    if "looser" in session:
        looser = session["looser"]
        flash(f"You have been logged out, {looser}!", "info")
    session.pop("looser", None)
    return redirect(url_for("login"))

if __name__ == "__main__":
    app.debug = True # show details of an error
    db.create_all() # create database
    app.run(port=4996) # run app on port 4996 (default is 5000 but does not work)