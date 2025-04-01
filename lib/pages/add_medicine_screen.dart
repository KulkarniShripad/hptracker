import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hptracker/constants/colors.dart';
import 'package:hptracker/constants/const_widgets.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  
  bool isLoading = false;
  String patientId = "P40"; // Replace this dynamically as needed

  @override
  void dispose() {
    _medicineController.dispose();
    _timeController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> addMedicineReminder() async {
    if (_medicineController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('medHistory').add({
        'pid': patientId,
        'medicine': _medicineController.text,
        'time': _timeController.text,
        'end_date': _endDateController.text,
        'date': FieldValue.serverTimestamp(),
        'doctor' : "Self",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine reminder added successfully!")),
      );

      _medicineController.clear();
      _timeController.clear();
      _endDateController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text("Add Medicine Reminder"),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: height * 0.02),

                Text(
                  "Enter Medicine Details",
                  style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),

                // Medicine Name Input
                TextFormField(
                  controller: _medicineController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Medicine Name",
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Time Input
                TextFormField(
                  controller: _timeController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Time (e.g., 08:00 AM)",
                    prefixIcon: Icon(Icons.timer),
                  ),
                ),
                SizedBox(height: height * 0.02),

                // End Date Input
                TextFormField(
                  controller: _endDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "End Date (YYYY-MM-DD)",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: height * 0.03),

                isLoading
                    ? progressIndicator(Colors.black)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: addMedicineReminder,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Save Reminder", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 16)),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
