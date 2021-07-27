from flask import Flask, redirect, url_for, render_template, request, session, flash
import joblib
import pandas as pd

app = Flask(__name__)
app.secret_key = "databusters" # needed for decrypting the data send to/from database

# Feature list used in the project, after EDA, cleaning and optimizing 
feature_list = ['Absolute Magnitude', 'Est Dia in KM(min)', 'Est Dia in KM(max)',
       'Epoch Date Close Approach', 'Relative Velocity km per sec',
       'Relative Velocity km per hr', 'Miles per hour',
       'Miss Dist.(kilometers)', 'Orbit ID', 'Minimum Orbit Intersection',
       'Jupiter Tisserand Invariant', 'Epoch Osculation', 'Eccentricity',
       'Semi Major Axis', 'Inclination', 'Asc Node Longitude',
       'Orbital Period', 'Perihelion Distance', 'Perihelion Arg',
       'Aphelion Dist', 'Perihelion Time', 'Mean Anomaly', 'Mean Motion']

# Mean values of features used
feature_means = [22.27, 0.2, 0.46, 1179880584425.01, 13.97, 50294.92, 
31251.31, 38413466.87, 28.3, 0.08, 5.06, 2457723.61, 0.38, 1.4, 13.37, 
172.16, 635.58, 0.81, 183.93, 1.99, 2457728.11, 181.17, 0.74]

# Example values for hazardous asteroids
hazardous_values = [20.3, 0.23, 0.52, 789552000000.0, 7.59, 27326.56, 
16979.66, 7622911.5, 22.0, 0.04, 4.56, 2458000.5, 0.35, 1.46, 4.24, 
259.48, 643.58, 0.95, 248.42, 1.97, 2458120.47, 292.89, 0.56]

# Example values for not hazardous asteroids
not_hazardous_values = [27.4, 0.01, 0.02, 790156800000.0, 11.17, 
40225.95, 24994.84, 42683616.0, 7.0, 0.01, 5.09, 2458000.5, 0.22, 
1.26, 7.91, 57.17, 514.08, 0.98, 18.71, 1.53, 2457902.34, 68.74, 0.7]

@app.route("/", methods=["POST", "GET"])
def welcome():
    if request.method == "POST": # POST used for keeping the user data from a form
        session.permanent = True  # <--- makes the permanent session
        return redirect(url_for("form"))
    else:
        return render_template("welcome.html")

@app.route("/form", methods=["POST", "GET"])
def form():
    if request.method == 'POST':
        # Print the form data to the console
        # And create dictionary and print it in a terminal
        form_dict = {}
        if "submit" in request.form:
            for key, value in request.form.items():
                form_dict[key] = value
                # print(f'{key}: {value}')
                form_dict.pop('submit', None)
        # If hazardous clicked the list of values is created
        elif "haz_but" in request.form:
            form_dict = dict(zip(feature_list, hazardous_values))
            print(form_dict)
        # If not hazardous clicked the list of values is created
        elif "not_haz_but" in request.form:
            form_dict = dict(zip(feature_list, not_hazardous_values))
            print(form_dict)
        else:
            pass
        
        # Check prediction on prvided data in query_df
        # query_df is built of the values dictionary
        query_df = pd.DataFrame.from_dict([form_dict])
        print(query_df)
        prediction = model.predict(query_df)

        # Save the form data to the session object
        session['is_hazardous'] = prediction.item(0)
        return redirect(url_for('results'))

    return render_template("form.html", len_fl = len(feature_list), feature_list = feature_list,
                            feature_means = feature_means, hazardous_values = hazardous_values,
                            not_hazardous_values = not_hazardous_values)

# webpage displaying the result of prediction
# different html code is displayed depending on the result 
@app.route("/results", methods=["GET"])
def results():
    return render_template("results.html")
    
# contact info
@app.route("/contacts")
def contacts():
    return render_template("contacts.html")

# Main app
# Running on port 4996
# Importing the model as pkl file
if __name__ == "__main__":
    app.debug = True
    model = joblib.load('models/xgboost_model.pkl')
    app.run(port=4996)


