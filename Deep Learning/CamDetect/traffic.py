from flask import Flask, redirect, url_for, render_template, request, session, flash
from werkzeug.utils import secure_filename
from keras.models import model_from_json
from tensorflow import keras
import numpy as np
import os
import joblib
import pandas as pd
from flask import Response
import cv2

app = Flask(__name__)
app.secret_key = "databusters" # needed for decrypting the data send to/from database

sign_names = ['Speed limit (20km/h)', 'Speed limit (30km/h)', 'Speed limit (50km/h)',
 'Speed limit (60km/h)', 'Speed limit (70km/h)', 'Speed limit (80km/h)',
 'End of speed limit (80km/h)', 'Speed limit (100km/h)',
 'Speed limit (120km/h)', 'No passing',
 'No passing for vehicles over 3.5 metric tons',
 'Right-of-way at the next intersection', 'Priority road', 'Yield', 'Stop',
 'No vehicles', 'Vehicles over 3.5 metric tons prohibited', 'No entry',
 'General caution', 'Dangerous curve to the left',
 'Dangerous curve to the right', 'Double curve', 'Bumpy road',
 'Slippery road', 'Road narrows on the right', 'Road work', 'Traffic signals',
 'Pedestrians', 'Children crossing', 'Bicycles crossing',
 'Beware of ice/snow', 'Wild animals crossing',
 'End of all speed and passing limits', 'Turn right ahead',
 'Turn left ahead', 'Ahead only', 'Go straight or right',
 'Go straight or left', 'Keep right', 'Keep left', 'Roundabout mandatory',
 'End of no passing', 'End of no passing by vehicles over 3.5 metric tons']

UPLOAD_FOLDER = 'C:/_JDSZR3/jdszr3-databusters_fork/DeepLearning/CamDetect/static/uploads'

camera = cv2.VideoCapture(0)

def prediction(image):
    loaded_model = keras.models.load_model("my_h5_model.h5")
    print("Loaded model from disk")
    prediction = loaded_model.predict(image)
    print("Prediction:{}".format(prediction))
    print(type(prediction))
    pred_list = prediction.tolist()
    print(type(pred_list))
    print(pred_list)
    pred_list = pred_list[0]
    print(pred_list)
    print(type(pred_list[0]))
    # pred_list = [int(x) for x in pred_list]
    # print(pred_list)

    max_value = max(pred_list)
    sign_idx = pred_list.index(max_value)
    # for pred_element in range(1, len(pred_list)):
    #     if pred_list[pred_element] > pred_list[pred_element-1]:
    #         sign_idx = pred_element
    #     else:
    #         continue
    
    print(sign_idx)
    print(sign_names[sign_idx])
    return sign_names[sign_idx]

def cam_prediction(image):
    loaded_model = keras.models.load_model("my_h5_model.h5")
    print("Loaded model from disk")
    prediction = loaded_model.predict(image)
    print("Prediction:{}".format(prediction))
    print(type(prediction))
    pred_list = prediction.tolist()
    print(type(pred_list))
    print(pred_list)
    pred_list = pred_list[0]
    print(pred_list)
    print(type(pred_list[0]))
    # pred_list = [int(x) for x in pred_list]
    # print(pred_list)

    max_value = max(pred_list)
    sign_idx = pred_list.index(max_value)
    # sign_idx = 0
    # for pred_element in range(len(pred_list)):
    #     if pred_list[pred_element] == 1:
    #         sign_idx = int(pred_element)
    #     else:
    #         pass
    
    print(sign_names[sign_idx])
    return sign_names[sign_idx]

def gen_frames():  
    while True:
        success, frame = camera.read()  # read the camera frame
        dim = (32, 32)
        frame4pred = cv2.resize(frame, dim) # resize image to 32x32 pixels
        print("frame shape: {}".format(frame4pred.shape))
        print(frame4pred)
        frame4pred = frame4pred / 255 # normalize image to scale 0-1
        print(frame4pred)
        frame4pred = frame4pred.reshape((1, frame4pred.shape[0], frame4pred.shape[1], frame4pred.shape[2])) # add 4th dimension
        print("frame after reshape: {}".format(frame4pred.shape))

        decision = cam_prediction(frame4pred)

        cv2.putText(frame, decision, (50,50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,255,0), 2)
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

# webpage displaying the result of prediction
# different html code is displayed depending on the result 
@app.route("/results", methods=["GET"])
def results():
    return render_template("results.html")


@app.route("/upload")
def upload_file():
   return render_template('upload.html')


@app.route('/uploader', methods = ['GET', 'POST'])
def uploader_file():
   if request.method == 'POST':
        f = request.files['fileToUpload']
        filename = secure_filename(f.filename)
        f_save_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        f_show_path = "/static/uploads/" + filename
        print(f_show_path)
        f.save(f_save_path)

        img = cv2.imread(f_save_path) # read the uploaded image
        print(type(img))
        print(img.shape)
        dim = (32, 32)
        img = cv2.resize(img, dim) # resize image to 32x32 pixels
        print(img.shape)
        print(img)
        img = img / 255 # normalize image to scale 0-1
        print(img)
        img = img.reshape((1, img.shape[0], img.shape[1], img.shape[2])) # add 4th dimension
        print(img.shape)

        decision = prediction(img) # send image do get a prediction

        # return 'file uploaded successfully'
        return render_template("results.html", user_image = f_show_path, prediction = decision)

# end-point with camera stream
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
    

