from flask import Flask, redirect, url_for, render_template, request, session, flash

app = Flask(__name__)
app.secret_key = "databusters" # needed for decrypting the data send to/from database

@app.route("/", methods=["POST", "GET"])
def welcome():
    if request.method == "POST": # POST used for keeping the user data from a form
        session.permanent = True  # <--- makes the permanent session
        flash("!")
        return redirect(url_for("form"))
    else:
        flash("!")
        return render_template("welcome.html")

@app.route("/form", methods=["POST", "GET"])
def form():
    if request.method == "POST": # POST used for keeping the user data from a form
        session.permanent = True  # <--- makes the permanent session
        flash("Data uploaded successfully!")
        return redirect(url_for("results"))
    else:
        flash("Data not uploaded!")
        return render_template("form.html")

@app.route("/results")
def results():
    return render_template("results.html")
    
@app.route("/contacts")
def contacts():
    return render_template("contacts.html")

if __name__ == "__main__":
    app.debug = True
    app.run(port=4996)


