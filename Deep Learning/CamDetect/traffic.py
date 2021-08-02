from flask import Flask, redirect, url_for, render_template, request, session, flash
from werkzeug.utils import secure_filename
from keras.models import model_from_json
from tensorflow import keras
import os
import joblib
import pandas as pd
from flask import Response
import cv2

app = Flask(__name__)
app.secret_key = "databusters" # needed for decrypting the data send to/from database

UPLOAD_FOLDER = 'C:/_JDSZR3/jdszr3-databusters_fork/DeepLearning/CamDetect/uploads'

camera = cv2.VideoCapture(0)

def gen_frames():  
    while True:
        success, frame = camera.read()  # read the camera frame
        if not success:
            break
        else:
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')  # concat frame one by one and show result

@app.route('/video_feed')
def video_feed():
    #Video streaming route. Put this in the src attribute of an img tag
    return Response(gen_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route("/", methods=["POST", "GET"])
def welcome():
    if request.method == "POST": # POST used for keeping the user data from a form
        session.permanent = True  # <--- makes the permanent session
        return redirect(url_for("camera"))
    else:
        return render_template("welcome.html")

# def index():
#     return render_template('index.html')

# webpage displaying the result of prediction
# different html code is displayed depending on the result 
@app.route("/results", methods=["GET"])
def results():
    # # load json and create model
    # json_file = open('model.json', 'r')
    # loaded_model_json = json_file.read()
    # json_file.close()
    # loaded_model = model_from_json(loaded_model_json)
    # # load weights into new model
    # loaded_model.load_weights("model_weights.h5")
    

    return render_template("results.html")

@app.route("/upload")
def upload_file():
   return render_template('upload.html')

@app.route('/uploader', methods = ['GET', 'POST'])
def uploader_file():
   if request.method == 'POST':
        f = request.files['fileToUpload']
        filename = secure_filename(f.filename)
        f.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        # # load json and create model
        # json_file = open('model.json', 'r')
        # loaded_model_json = json_file.read()
        # json_file.close()
        # loaded_model = model_from_json(loaded_model_json)
        # # load weights into new model
        # loaded_model.load_weights("model_weights.h5")
        # print("Loaded model from disk")
        loaded_model = keras.models.load_model("my_h5_model.h5")
        print("Loaded model from disk")
        


        return 'file uploaded successfully'

@app.route("/web_cam", methods=["GET"])
def web_cam():
    return render_template("web_cam.html")

# contact info
@app.route("/contacts")
def contacts():
    return render_template("contacts.html")




if __name__ == "__main__":
    app.debug = True
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
    app.run(port=4996)

