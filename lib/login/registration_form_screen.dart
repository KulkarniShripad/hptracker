import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hptracker/constants/colors.dart';
import 'package:hptracker/constants/const_widgets.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  bool isLoading = false;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _weightController = TextEditingController();
  final _caretakerController = TextEditingController(); // Caretaker phone input
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> caretaker = []; // List of caretaker phone numbers
  int selectedGender = 0;

  Future<void> addPatient({
    required String name,
    required int age,
    required String gender,
    required int weight,
    required bool isON,
    required String applicationId,
    required List<String> caretakerNumbers,
  }) async {
    String pid = (Random().nextInt(9000000000) + 1000000000).toString();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> patientData = {
      "name": name,
      "age": age,
      "gender": gender,
      "weight": weight,
      "isON": isON,
      "application_id": applicationId,
      "caretaker": caretakerNumbers,
    };

    await firestore.collection("patients").doc(pid).set(patientData);
    print("Patient added with ID: $pid");

    setState(() {
      isLoading = false;
    });
  }

  void _addCaretakerNumber() {
    String phone = _caretakerController.text.trim();
    if (phone.isNotEmpty && phone.length == 10) {
      setState(() {
        caretaker.add(phone);
        _caretakerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit phone number")),
      );
    }
  }

  void _submitForm() async {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        caretaker.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add caretakers")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    addPatient(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      gender: selectedGender == 0 ? "male" : "female",
      weight: int.parse(_weightController.text),
      isON: true,
      applicationId: "A18",
      caretakerNumbers: caretaker,
    );
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: "123abc",
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigator()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text("Registration Form"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.023),
                  child: Column(
                    children: [
                      buildTextfield("Name", _nameController, true, TextInputType.text, width),
                      buildTextfield("Mobile Number", _mobileController, true, TextInputType.number, width),
                      buildTextfield("Email ID", _emailController, true, TextInputType.emailAddress, width),
                      buildTextfield("Age", _ageController, true, TextInputType.number, width),
                      buildTextfield("Weight", _weightController, true, TextInputType.number, width),

                      // Gender Selection
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.023),
                        child: Row(
                          children: [
                            const Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Radio<int>(
                              value: 0,
                              groupValue: selectedGender,
                              onChanged: (value) => setState(() => selectedGender = value!),
                            ),
                            const Text('Male'),
                            Radio<int>(
                              value: 1,
                              groupValue: selectedGender,
                              onChanged: (value) => setState(() => selectedGender = value!),
                            ),
                            const Text('Female'),
                          ],
                        ),
                      ),

                      // Caretaker Number Input
                      buildTextfield("Caretaker Phone", _caretakerController, false, TextInputType.phone, width),
                      ElevatedButton(
                        onPressed: _addCaretakerNumber,
                        child: const Text("Add Caretaker"),
                      ),

                      // Display Caretaker Numbers
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: caretaker.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(caretaker[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() => caretaker.removeAt(index)),
                          ),
                        ),
                      ),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? Container(color: Colors.black.withOpacity(0.8))
                : const SizedBox.shrink(),
            isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          color: Colors.white,
                          width: width * 0.3,
                          height: width * 0.3,
                          child: progressIndicator(Colors.black),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
