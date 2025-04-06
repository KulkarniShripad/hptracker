from flask import Flask, render_template, request, redirect, jsonify
import threading
import time 
import firebase_admin
from firebase_admin import credentials, firestore

from twilio.rest import Client

# Twilio Account Credentials (Replace with your details)
TWILIO_ACCOUNT_SID = "ID"
TWILIO_AUTH_TOKEN = "Passwird"
TWILIO_PHONE_NUMBER = "num"  # Your Twilio phone number

def send_sms_notification(phone_numbers, message):
    """Send an SMS notification to a list of phone numbers."""
    client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

    for number in phone_numbers:
        try:
            message_obj = client.messages.create(
                body=message,
                from_=TWILIO_PHONE_NUMBER,
                to=f"+91{number}"  # Assuming Indian phone numbers
            )
            print(f"Sent to {number}: Message SID {message_obj.sid}")
        except Exception as e:
            print(f"Failed to send to {number}: {str(e)}")

# List of phone numbers
phone_numbers = ["9623820809"]
message = ":-\n\n\nHey bro medicine lele yar!! kayko bakchodi kar raha"

# Send SMS
send_sms_notification(phone_numbers, message)



app = Flask(__name__)



# Shared variable
status_flag = False

def monitor_variable():
    print("in")
    global status_flag
    while True:
        if status_flag:  
            run_function()  # Call the function
            status_flag = False  # Reset flag after execution
        time.sleep(1)  # Avoid CPU overuse

def run_function():
    """Function to execute when status_flag is True."""
    print("Executing important task...")

@app.route('/check')
def update_status():
    """Endpoint to update status_flag"""
    send_sms_notification(phone_numbers, message)
    global status_flag
    status_flag = True
    return "Status updated to True"




# 🔹 Home Route
@app.route('/')
def home():
    return render_template("home.html") 

# Initialize Firebase Firestore
cred = credentials.Certificate("hp.json")  # Update with your file
firebase_admin.initialize_app(cred)
db = firestore.client()


# 🔹 Add Patient
@app.route('/add_patient', methods=['POST'])
def add_patient():
    data = request.json
    pid = data.get('pid')  # Unique Patient ID

    patient_ref = db.collection('patients').document(pid)
    patient_ref.set({
        "name": data["name"],
        "age": data["age"],
        "gender": data["gender"],
        "weight": data["weight"],
        "caretaker": data["caretaker"],
        "idON": data["idON"],
        "application_id": data["application_id"]
    })

    return jsonify({"message": "Patient added successfully!"}), 200

# 🔹 Add Prescription
@app.route('/add_prescription', methods=['POST'])
def add_prescription():
    data = request.json
    
    prescription_ref = db.collection("medHistory").document()
    prescription_ref.set({
        "date": data["date"],
        "doctor": data["doctor"],
        "medicine": data["medicine"],
        "description": data["description"],
        "end": data["end"],
        "time": data["time"],
        "pid" :data["pid"]
    })

    return jsonify({"message": "Prescription added successfully!"}), 200

# 🔹 Fetch Patient Details
@app.route('/get_patient/<pid>', methods=['GET'])
def get_patient(pid):
    patient_ref = db.collection('patients').document(pid)
    patient = patient_ref.get()
    
    if patient.exists:
        return jsonify(patient.to_dict()), 200
    else:
        return jsonify({"error": "Patient not found"}), 404

# 🔹 Fetch Prescriptions
@app.route('/get_prescriptions/<pid>', methods=['GET'])
def get_prescriptions(pid):
    prescriptions = db.collection("patients").document(pid).collection("medHistory").stream()
    
    result = []
    for prescription in prescriptions:
        result.append(prescription.to_dict())
    data = { 
        "created_at" : "March 27, 2025 at 3:56:08 PM UTC+5:30",
        "end_date" : "2025-04-12",
        "medicine": "paracetamol ",
        "pid":  "P40",
        "time":"05.30"
    }

    return jsonify(data), 200

# Function to Update idON to True 

def update_idon_to_true(pid):
    db = firestore.client()  # Get Firestore client
    patient_ref = db.collection('patients').document(pid)

    # Check if patient exists
    patient = patient_ref.get()
    if patient.exists:
        patient_ref.update({"idON": True})
        return {"message": "idON updated to True successfully!"}
    else:
        return {"error": "Patient not found"}
    
# Function to Update idON to False 

def update_idon_to_false(pid):
    db = firestore.client()  # Get Firestore client
    patient_ref = db.collection('patients').document(pid)

    # Check if patient exists
    patient = patient_ref.get()
    if patient.exists:
        patient_ref.update({"idON": False})
        return {"message": "idON updated to False successfully!"}
    else:
        return {"error": "Patient not found"}

def update_idon_to_true(pid):
    db = firestore.client()  # Get Firestore client
    patient_ref = db.collection('patients').document(pid)

    # Check if patient exists
    patient = patient_ref.get()
    if patient.exists:
        patient_ref.update({"idON": True})
        return {"message": "idON updated to True successfully!"}
    else:
        return {"error": "Patient not found"}
    
    



# @app.route("/")
# def home():
#     monitor_variable()
#     return render_template("index.html", title="Home")


if __name__ == "__main__":
    app.run(debug=True)
